//
//  AddProfileViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 14/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class AddProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var addProfileHeaderView: UIView!
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    @IBOutlet weak var addProfileTableView: UITableView!
  
    var profileInfoArray = [AUserInfo]()
   
    //MARK: - UIViewControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.initialMethod()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        callApiMethodForViewProfile()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Helper Methods
   
    func initialMethod() {
        
        self.addProfileHeaderView.isHidden = false
        
        self.addProfileTableView.estimatedRowHeight = 400
      
        self.addProfileTableView.register(UINib(nibName:"ContactTableViewCell",bundle:nil), forCellReuseIdentifier: "ContactTableViewCell")
        self.addProfileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
    }
    
    //MARK: - UIButton Actions Methods
   
    @IBAction func addNewProfileButtonAction(_ sender: UIButton) {
        
        let vcObj = EditProfileViewController()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - UITableViewDataSource Methods
   
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat  {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)as! ContactTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
       
        let profileInfo = profileInfoArray[indexPath.row]
      
        cell.contactNameLabel.text = profileInfo.categoryProfileStatusString
        cell.contactTitleLabel.text = profileInfo.categoryProfileTypeString
        
        if profileInfo.categoryProfileImage != nil {
            cell.contactImageView.sd_setImage(with: profileInfo.categoryProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)

        }
        cell.callButton.isHidden = true
        cell.chatButton.isHidden =  true
        cell.contactNameTrailingConstant.constant = 5
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell  = tableView .cellForRow(at: indexPath)!
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "         ") {
            
            (rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            _ = AlertController.alert("", message: "Are you sure you want to delete this profile?", controller: self, buttons: ["No","Yes"], tapBlock: { (UIAlertAction, index) in
                
                if(index == 1) {
                    
                    self.callApiMethodToDeleteProfile(userObj: self.profileInfoArray[indexPath.row])
                    
                }
            })
        }
        
        let img2 = UIImageView(image: UIImage(named: "delete_icon"))
        img2.frame = CGRect(x: cell.frame.size.width + 20, y: cell.frame.size.height / 3, width: 40, height: 40)
        img2.contentMode = .scaleAspectFit
        cell.contentView.addSubview(img2)
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    //MARK: - WebService Method
    
    func callApiMethodForViewProfile() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict =  [KUser_Id : userId]

        ServiceHelper.request(params: paramDict, method: .post, apiName: KViewMultipleprofile, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        let reponseArray = response.validatedValue("view_multiple_profile_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
                                        
                        self.profileInfoArray = AUserInfo.getProfileListArray(responceArray: reponseArray )

                        self.addProfileTableView.reloadData()
                    
                    } else if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 400 {
                        
                        // No profile added yet
                        
                    } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }

    func callApiMethodToDeleteProfile(userObj:AUserInfo) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict =  [KUser_Id : userId,
                          KprofileType : userObj.categoryProfileTypeString]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KDeleteMultipleprofile, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                       
                        _ =     presentAlertWithOptions("", message: response["message"] as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in

                            self.callApiMethodForViewProfile()
                        })
                        
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
