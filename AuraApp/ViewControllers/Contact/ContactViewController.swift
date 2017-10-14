
//
//  ContactViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 12/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import Contacts

protocol doneButtonDelegate {
    func doneButtonAction(selectedContacts : NSMutableArray)
    
}

class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var doneButtonDelegate : doneButtonDelegate?
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contactTableView: UITableView!
    
    var isCheckBox   = Bool()
    var isBackButton = Bool()
  
    var isSelectedContacts = Array<Any>()

    var contactObj  = ContactInfo()
    var contactInfoArray = [ContactInfo]()
    
    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialMethod()
        
        if(isCheckBox) {
            self.doneButton.isHidden = false
        }
        
        self.fetchContact()

    }

    //MARK: - Helper Method

    func initialMethod() {
        
        self.backButton.isHidden = (isBackButton) ? true : false
    
        self.contactTableView.estimatedRowHeight = 400
        self.contactTableView.register(UINib(nibName:
            "ContactTableViewCell",bundle:nil), forCellReuseIdentifier: "ContactTableViewCell")
        self.contactTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.contactTableView.delegate = self
        self.contactTableView.dataSource = self

    }
    
    func fetchContact() {
       
        var contactArray = [ContactInfo]()

        var hud = MBProgressHUD(for: kAppDelegate.window!)
        
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
        }
        
        hud?.show(animated: true)
        
        let contactStroe = CNContactStore()
   
        contactStroe.requestAccess(for: .contacts, completionHandler: { (granted, error) -> Void in
            if granted {
                
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactFamilyNameKey,
                    CNContactImageDataAvailableKey] as [Any]
                
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStroe.defaultContainerIdentifier())
                var contacts: [CNContact]! = []
               
                do {
                    contacts = try contactStroe.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])// [CNContact]
                } catch {
                    
                }
                
                for contact in contacts {
                    var phoneStr = ""
                    var nameStr = ""
                    var image = UIImage()

                    var number: CNPhoneNumber!
                    if contact.phoneNumbers.count > 0 {
                        number = contact.phoneNumbers[0].value

//                        if(contact.imageDataAvailable) {
//                        image = UIImage(data:contact.imageData!,scale:1.0)!
//                       
//                        } else {
//                            image = UIImage(named: "profile_img")!
//
//                        }
                        phoneStr = number.stringValue.replaceString("-", withString: "")
                    }
                    
                    nameStr = contact.familyName + contact.givenName
                    
                    if !nameStr.isEmpty && !phoneStr.isEmpty {
                        let friend = ContactInfo()
                        friend.contactNameString = nameStr
                        friend.contactNumber = phoneStr
                        friend.contactImage = image
                        contactArray.append(friend)
                    }
                }

            }
            
            DispatchQueue.main.async {
                hud?.hide(animated: true)
            }
            
            self.callApiMethodForContactList(fetchedContactArray:contactArray)
        })

    }
   
    //MARK: - UITableViewDataSource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.contactInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell",for:indexPath)as! ContactTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let contactInfo = contactInfoArray[indexPath.row] 

        cell.contactNameLabel.text = contactInfo.contactStatus
        cell.contactTitleLabel.text = contactInfo.contactNameString
       
        cell.callButton.buttonIndexPath = indexPath
        cell.chatButton.buttonIndexPath = indexPath
        
        cell.contactImageView.sd_setImage(with: contactInfo.contactImageUrl,placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
        cell.callButton.addTarget(self,action : #selector(callButtonAction(_:)),for: .touchUpInside)
        cell.chatButton.addTarget(self,action:#selector(chatButtonAction(_:)), for: .touchUpInside)
        cell.checkBoxButton.addTarget(self,action:#selector(checkBoxButtonAction(_:)),for: .touchUpInside)
       
        cell.checkBoxButton.tag = indexPath.row + 100
        cell.checkBoxButton.isHidden = !isCheckBox
        cell.checkBoxButton.isSelected = contactInfo.isCheckedBox
        
        if(isCheckBox) {
            cell.chatButtonLeftConstraint.constant = 26
         
        } else {
            cell.chatButtonLeftConstraint.constant = 3
 
        }

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailVc = ContactDetailViewController()
        contactDetailVc.contactId = contactInfoArray[indexPath.row].contactUserId
        self.navigationController?.pushViewController(contactDetailVc, animated: true)
    }
    
    //MARK: - UIButton Actions
    
    @IBAction func backButtonAction(_ sender: UIButton) {
       
       self.navigationController?.popViewController(animated : true)
    }
    
    @IBAction func callButtonAction(_ sender: NotificationButton) {
        
        if let phoneCallURL = NSURL(string: "tel:\(contactInfoArray[sender.buttonIndexPath.row].contactNumber)") {
            let application = UIApplication.shared
          
            if application.canOpenURL(phoneCallURL as URL) {
                application.openURL(phoneCallURL as URL)
            
            } else {
                _ = AlertController.alert("", message: "Call facility is not available")
            }
        }
    }
    
    @IBAction func chatButtonAction(_ sender: NotificationButton) {
        
//        if contactInfoArray[sender.buttonIndexPath.row].isFriend {
//            let chatVc = ChatViewController()
//            chatVc.contactId = contactInfoArray[sender.buttonIndexPath.row].contactUserId
//            chatVc.recieverName = contactInfoArray[sender.buttonIndexPath.row].contactNameString
//            chatVc.recieverImageProfile = contactInfoArray[sender.buttonIndexPath.row].contactImageUrl
//            
//            self.navigationController?.pushViewController(chatVc, animated: true)
//        } else {
//            _ = AlertController.alert("", message: "Please add " + contactInfoArray[sender.buttonIndexPath.row].contactNameString + " as your friend to initiate chat.")
//
//        }
        
        let chatVc = ChatViewController()
        chatVc.contactId = contactInfoArray[sender.buttonIndexPath.row].contactUserId
        chatVc.recieverName = contactInfoArray[sender.buttonIndexPath.row].contactNameString
        chatVc.recieverImageProfile = contactInfoArray[sender.buttonIndexPath.row].contactImageUrl

        self.navigationController?.pushViewController(chatVc, animated: true)
    }
    
    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
     
        let index = sender.tag - 100
        let obj = contactInfoArray[index] 
        obj.isCheckedBox = !obj.isCheckedBox
        contactTableView.reloadData()
    }

    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        let isSelectedContact = NSMutableArray()
        
        for obj in contactInfoArray {
            
            if obj.isCheckedBox {
                isSelectedContact.add(obj.contactNumber)

            }
        }
        
    self.doneButtonDelegate?.doneButtonAction(selectedContacts: isSelectedContact)
    self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - WebServiceMethod
    
    func callApiMethodForContactList(fetchedContactArray: Array<ContactInfo> ) {

        var phoneNumberArray = [String]()
       
        for obj in fetchedContactArray {
            phoneNumberArray.append(obj.contactNumber
            )
        }
        
        let paramDict = [KcontactList : phoneNumberArray
                        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KAuraContacts, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
             
                        let reponseArray = response.validatedValue("data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
                        
                        self.contactInfoArray = ContactInfo.getContactListArray(postInfo: reponseArray)
                        
                        if self.contactInfoArray.count == 0 {
                            
                            _ = AlertController.alert("", message: "None of your contact registerd with AURA.")

                            
                        } else {
                            DispatchQueue.main.async {
                                self.contactTableView.reloadData()
                            }
                            
                        }
               
                    } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
             }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
        }
    }
    
    /*
    func callApiMethodToCheckFriendshipStatus(contactObj: ContactInfo) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId,
                         "friend_id" : contactObj.contactUserId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KFriendshipStatus, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        let chatVc = ChatViewController()
                        chatVc.contactId = contactObj.contactUserId
                        chatVc.recieverName = contactObj.contactNameString
                        chatVc.recieverImageProfile = contactObj.contactImageUrl
                        
                        self.navigationController?.pushViewController(chatVc, animated: true)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
*/
    
    //MARK: - Menory management method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
extension Data {
    var uiImage: UIImage? {
        return UIImage(data: self)
    }
}

