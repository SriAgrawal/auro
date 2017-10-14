//
//  SearchViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 16/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import Contacts

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
 
    var contactInfoArray = [ContactInfo]()
    
    var contactArray = [ContactInfo]()

    var filterDataArray = [ContactInfo]()
    
    //MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialMethod()
         fetchContactLst()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Helper Method
    
    func initialMethod() {
        
        self.searchTextField.delegate = self
        self.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.searchTableView.estimatedRowHeight = 400
        self.searchTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil),forCellReuseIdentifier : "ContactTableViewCell")
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        searchTextField.autocapitalizationType = .words
        self.searchView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func fetchContactLst() {
        
            var hud = MBProgressHUD(for: kAppDelegate.window!)
            
            if hud == nil {
                hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
            }
            
            hud?.show(animated: true)
            
            let contactStroe = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            contactStroe.requestAccess(for: .contacts, completionHandler: { (granted, error) -> Void in
                if granted {
                    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStroe.defaultContainerIdentifier())
                    var contacts: [CNContact]! = []
                    do {
                        contacts = try contactStroe.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])// [CNContact]
                    }catch {
                        
                    }
                    for contact in contacts {
                        var phoneStr = ""
                        var nameStr = ""
                        var image = UIImage()
                        
                        var number: CNPhoneNumber!
                        if contact.phoneNumbers.count > 0 {
                            number = contact.phoneNumbers[0].value
                            
                            if(contact.imageDataAvailable) {
                                image = UIImage(data:contact.thumbnailImageData!)!
                                
                            } else{
                                image = UIImage(named: "profile_img")!
                            }
                            
                            phoneStr = number.stringValue.replaceString("-", withString: "")
                        }
                        
                        nameStr = contact.familyName + contact.givenName
                        
                        if !nameStr.isEmpty && !phoneStr.isEmpty {
                            let friend = ContactInfo()
                            friend.contactNameString = nameStr
                            friend.contactNumber = phoneStr
                            friend.contactImage = image
                            self.contactArray.append(friend)
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    hud?.hide(animated: true)
                }
                
                self.callApiMethodForContactList(fetchedContactArray:self.contactArray)
            })
            
    }

    func setNameImageOfUnrgisteredContacts(arr:Array<ContactInfo>) {
        
        for obj in arr {
            
            for obj1 in contactArray {
                
                if obj.contactNumber == obj1.contactNumber {
                    
                    self.contactInfoArray.append(obj1)
                }
            }
        }
        
        self.filterDataArray = contactInfoArray
        self.searchTableView.reloadData()
        
    }
    
    //MARK: - UITableview datasource and delegate methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterDataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)as! ContactTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let contactInfoObj = filterDataArray[indexPath.row]
        
        cell.contactTitleLabel.text = contactInfoObj.contactNameString
        cell.contactNameLabel.text = contactInfoObj.contactNumber
        cell.contactImageView.image = contactInfoObj.contactImage

        cell.callButton.isHidden = true
        cell.chatButton.isHidden =  true
        
        cell.inviteButton.isHidden = false
        
        cell.inviteButton.buttonIndexPath = indexPath
        cell.inviteButton.addTarget(self, action: #selector(inviteButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: - UITextField Delegate
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        filterTableViewForEnterText(searchText: str as String)
        
        return true
        
    }
    
    // MARK: - Method for searching contacts
    
    func filterTableViewForEnterText(searchText: String) {
        
        self.filterDataArray.removeAll()
        
        if searchText.trimWhiteSpace().length != 0 {
            
                for contactObj in self.contactInfoArray {
                    
                    if (contactObj.contactNameString).contains(searchText) {
                        self.filterDataArray.append(contactObj)
                    }
                }

        } else {
            self.filterDataArray = self.contactInfoArray
        }
        
        
        self.searchTableView.reloadData()
    }

    //MARK: - UIButton Actions Methods
    
    @IBAction func inviteButtonAction(_ sender: NotificationButton) {
        
        // hit api to invite
        let obj = contactInfoArray[sender.buttonIndexPath.row]
        callApiMethodToInvite(inviteNumber: obj.contactNumber)
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
      
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - WebServiceMethod
    
    func callApiMethodForContactList(fetchedContactArray: Array<ContactInfo> ) {
        
        var phoneNumberArray = [String]()
        
        for obj in fetchedContactArray {
            phoneNumberArray.append(obj.contactNumber)
        }
        
        let paramDict = [
            KcontactList : phoneNumberArray
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KAllContacts, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        var unrgisterArray = [ContactInfo]()

                        unrgisterArray = ContactInfo.getAllContactArray(conatctInfo: response)
                        
                        self.setNameImageOfUnrgisteredContacts(arr:unrgisterArray)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
        }
    }

    func callApiMethodToInvite(inviteNumber:String) {
        
        let paramDict =  ["mobile_number" : inviteNumber]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KInvitOnAura, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }

}
