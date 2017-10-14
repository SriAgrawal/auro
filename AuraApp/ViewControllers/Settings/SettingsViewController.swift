//
//  SettingsViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/12/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var settingsView: UIView!
    
    //MARK: - UIViewController LifeCycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
    }
    
    //MARK:  - Helper Method
    
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        self.settingsTableView.register(UINib(nibName:"SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SettingsTableViewCell") as? SettingsTableViewCell
        
        settingsTableView.allowsSelection = true
        cell?.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell?.settingsImageView.image = UIImage(named: "profile_icon.png")
            cell?.settingsLabel.text = "Profile"
            break
            
        case 1:
            cell?.settingsImageView.image = UIImage(named: "info_icon.png")
            cell?.settingsLabel.text = "Update Information"
            break
            
        case 2:
            cell?.settingsImageView.image = UIImage(named: "info_icon.png")
            cell?.settingsLabel.text = "Change Number"
            break
            
        case 3:
            cell?.settingsImageView.image = UIImage(named: "cellicular.png")
            cell?.settingsLabel.text = "Data Usage"
            break
            
//        case 4:
//            cell?.settingsImageView.image = UIImage(named: "backup_icon.png")
//            cell?.settingsLabel.text = "Backup"
//            break
            
        case 4:
            cell?.settingsImageView.image = UIImage(named: "feedback_icon.png")
            cell?.settingsLabel.text = "Feedback"
            break
            
        case 5:
            cell?.settingsImageView.image = UIImage(named: "t&c")
            cell?.settingsLabel.text = "Terms & Services"
            break
            
        case 6:
            cell?.settingsImageView.image = UIImage(named: "t&c")
            cell?.settingsLabel.text = "Privacy Policy"
            break
            
        case 7:
            cell?.settingsImageView.image = UIImage(named: "delete_icon_black")
            cell?.settingsLabel.text = "Delete Account"
            break
            
        default:
            break
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
       
        case 0:
            let vcObj = AddProfileViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 1:
            let vcObj = UpdateInfoViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 2:
            let vcObj = LoginViewController()
            vcObj.isFromProfile = true
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 3:
            let vcObj = CellicularViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
//        case 4:
//            let vcObj = BackupViewController()
//            self.navigationController?.pushViewController(vcObj, animated: true)
//            break
            
        case 4:
            let vcObj = FeedbackViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 5:
            let termVc = TermsServicesViewController()
            termVc.isController = true
            
            self.navigationController?.pushViewController(termVc, animated: true)
            
            break
        
        case 6:
            let termsVc = TermsServicesViewController()
            termsVc.isController = false
            self.navigationController?.pushViewController(termsVc, animated: true)
            
            break
       
        case 7:
            
            _ = AlertController.alert("", message: "Are you sure you want to delete your account?", controller:self ,buttons: ["Cancel","Ok"],tapBlock: {
                
                (UIAlertAction,index)in
                
                if (index == 1) {

                    // hit api to delete account
                    self.callApiMethodToDeleteAccount()

                }
            })
            
            break
        default:

            break
        }
    }
    
    //MARK: - Web Api Methods
    
    func callApiMethodToDeleteAccount() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict =  [KId : userId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName:KAccountDelete, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                       
                        APPDELEGATE.logOut()
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                    
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    //MARK:- Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
