//
//  CategoryPopUpViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 24/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

protocol toSendResponseBackDelegate{
     func afterAcceptingFriendRequest(responseMessage: String)
}

class CategoryPopUpViewController: UIViewController {
    
     @IBOutlet weak var categoryButton: UIButton!

     @IBOutlet weak var senderNameLabel: UILabel!
     
     var categoryArray = [AUserInfo]()
     var selectedCategory = AUserInfo()
     
     var friendId = String()

     var senderName = String()

     var alertDelegate : toSendResponseBackDelegate?

     let categoryType = DropDown()
    
     lazy var dropDowns: [DropDown] = {
        return [
            self.categoryType
        ]
    
     }()
    
   var addCategoryArray = [String]()
    
    //MARK: - setting DropDown
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
        
    }
    
     //MARK : -UIViewControllerLifeCycle Methods
    
     override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
     
          setupDropDowns()
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialMethod() {
     self.categoryButton.layer.borderColor = UIColor.lightGray.cgColor
     self.senderNameLabel.text = self.senderName + " want to add you."
    
     }
    
    //MARK: -dropDown Setup
    
    func setupDropDowns() {
     
     dropDowns.forEach { $0.dismissMode = .onTap }
     dropDowns.forEach { $0.direction = .any }
     
     setupCategoryDropDown( )
        
    }
    
    func setupCategoryDropDown() {
        
        categoryType.anchorView = categoryButton
        
        self.categoryType.bottomOffset = CGPoint(x: 0, y: categoryButton.bounds.height)
     
        
        // Action triggered on selection
        categoryType.selectionAction = { [unowned self] (index, item) in
          
          self.selectedCategory = self.categoryArray[index]
          self.categoryButton.setTitle(item, for: .normal)
        }
        
    }
    @IBAction func dropDownButtonAction(_ sender: UIButton) {
          self.callApiMethodForGetCategory()

     }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func dismisButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func okButtonAction(_ sender: UIButton) {
     self.callApiMethodToAcceptFriendRequest()
     }

  //MARK: - WebServiceMethods
    
    func callApiMethodForGetCategory() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KGetProfiletype, hudType: .simple) { (result, error, httpCode) in
            
          if error == nil {
                    
               if let response = result as? Dictionary<String, AnyObject> {

                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                         
                         let reponseArray = response.validatedValue("multiple_profile_type_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
                         
                         self.categoryArray.removeAll()
                         self.addCategoryArray.removeAll()
                         
                         self.categoryArray = AUserInfo.getProfileCategory(responceArray: reponseArray)
                         
                         for profileItem in self.categoryArray {
                              self.addCategoryArray.append(profileItem.categoryProfileTypeString)
                         }
                         
                         self.categoryType.dataSource = self.addCategoryArray
                         
                         self.categoryType.show()
                         
                    } else {
                         _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
               
               }
               
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    

     func callApiMethodToAcceptFriendRequest() {
                   
          guard let userId = defaults.value(forKey: pUserId) as? String else {
               return
          }
          
          let paramDict = [
               KUser_Id : userId,
               KFriendId : self.friendId,
               KcategoryProfileType : "\(self.selectedCategory.categoryId)"
          ] as [String : Any]
          
          ServiceHelper.request(params: paramDict, method: .post, apiName: KAcceptFriendRequest, hudType: .simple) { (result, error, httpCode) in
               
               if error == nil {
                    
                    if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue(pStatusCode, expected: NSNumber.self) as! NSNumber) == 200 {
                      
                         self.dismiss(animated: false, completion: nil)
                         
                         self.alertDelegate?.afterAcceptingFriendRequest(responseMessage: response.validatedValue("message", expected: "" as AnyObject) as! String)

                    } else {
                         
                         _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                         self.dismiss(animated: false, completion: nil)

                         }
                  }
               }
               else {
                    
                    _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
          }
     }
     
     }

