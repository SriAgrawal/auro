//
//  ChooseAccountViewController.swift
//  Aura
//
//  Created by Akash Mehrotra on 17/08/17.
//  Copyright © 2017 Akash Mehrotra. All rights reserved.
//

import UIKit

protocol customAlertDelegateCategory {
    func alertCompletetion()
    func afterAddingCategory(responseMessage: String)
}

class ChooseAccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var alertDelegate : customAlertDelegateCategory?
    
    @IBOutlet weak var chooseAccountTableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chooseAccountView: UIView!

    @IBOutlet weak var submitButton: UIButton!
    
    var profileArray = [AUserInfo]()
    
    var selectedprofile = AUserInfo()
    
    var friendId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMethod()
        
        callApiMethodForViewProfile()

    }
   
    //MARK : - Helper Methods
    
    func initialMethod() {
        
        self.submitButton.isHidden = true
        
        self.chooseAccountTableView.register(UINib(nibName: "ChooseAccountTableViewCell", bundle: nil),forCellReuseIdentifier : "ChooseAccountTableViewCell")
 
    }
    
    // MARK: - TableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseAccountTableViewCell", for: indexPath) as! ChooseAccountTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.chooseButton.buttonIndexPath = indexPath
        cell.chooseButton.setTitle(profileArray[indexPath.row].categoryProfileTypeString, for: .normal)
        
        cell.chooseButton.isSelected = (selectedprofile.categoryId == profileArray[indexPath.row].categoryId) ? true : false
    
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedprofile = profileArray[indexPath.row]
        self.chooseAccountTableView.reloadData()
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated:false, completion : nil)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        callApiMethodToAddFriendInCategory()
    }
    
    @IBAction func addNewCategoryBtnAction(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
        self.alertDelegate?.alertCompletetion()
        
    }
    
    //MARK: - Web Api Methods
    
    func callApiMethodForViewProfile() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KGetProfiletype, hudType: .simple) { (result, error, httpCode) in
            
            let response = result as! Dictionary<String, AnyObject>
            
            if error == nil {
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                    
                    let reponseArray = response.validatedValue("multiple_profile_type_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
                    
                    self.profileArray = AUserInfo.getProfileCategory(responceArray: reponseArray)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        
                        self.tableViewHeightConstraint.constant = self.chooseAccountTableView.contentSize.height+20
                        self.chooseAccountTableView.separatorStyle = UITableViewCellSeparatorStyle.none
                        
                    }
                    
                    self.submitButton.isHidden = (self.profileArray.count != 0) ? false : true
                    
                    self.chooseAccountTableView.reloadData()
                    
                } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
                
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
            
        }
    }
   
    
    func callApiMethodToAddFriendInCategory() {
    
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId,
            KFriendRequestSender: friendId,
            KProfileTypeName: "\(selectedprofile.categoryId)"
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KAddFriendByCategory, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.dismiss(animated: false, completion: nil)
                        
                        self.alertDelegate?.afterAddingCategory(responseMessage: response.validatedValue("message", expected: "" as AnyObject) as! String)

                   
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
        }
    }

    //MARK: - Memory management method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
