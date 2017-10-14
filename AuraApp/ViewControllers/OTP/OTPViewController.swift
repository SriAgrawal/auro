//
//  OTPViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 14/09/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    
    var loginInfo = LoginInfo()
    var isFromProfile : Bool = false
    var isUserRegistered : Bool = false

    //MARK: - UIVIEWControllerLifeCycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.intialMethod()
    }
    
    //MARK: - Helper Mthods
    
    func intialMethod() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //MARK:- Validation Methods
    
    func isAllFieldVarified() -> Bool {
        
        var isValid = false
        
        if loginInfo.firstTextField.trimWhiteSpace().length == 0
        {
            presentAlert("", msgStr: "Please enter otp", controller: self)
        } else if loginInfo.secondTextField.trimWhiteSpace().length == 0
        {
            presentAlert("", msgStr: "Please enter otp", controller: self)
        }else if loginInfo.thirdTextField.trimWhiteSpace().length == 0
        {
            presentAlert("", msgStr: "Please enter otp", controller: self)
        } else if loginInfo.fourthTextField.trimWhiteSpace().length == 0
        {
            presentAlert("", msgStr: "Please enter otp", controller: self)
        }
        else{
            isValid = true
        }
        
        return isValid
        
    }
    
    //MARK: UITextFieldDelegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.characters.count)! < 1  && string.characters.count > 0){
            let nextTag = textField.tag + 1
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag);
            
            if (nextResponder == nil){
                nextResponder = textField.superview?.viewWithTag(1001);
            }
            textField.text = string
            nextResponder?.becomeFirstResponder()
            return false;
        }
        else if ((textField.text?.characters.count)! >= 1  && string.characters.count == 0){
            // on deleting value from Textfield
            let previousTag = textField.tag - 1
            
            // get next responder
            var previousResponder = textField.superview?.viewWithTag(previousTag);
            
            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1001);
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false;
        }
        else if ((textField.text?.length)! == 1){
            let nextTag = textField.tag + 1
            textField.text = ""
            // get next responder
            let nextResponder = textField.superview?.viewWithTag(nextTag);
            textField.text = string
            nextResponder?.becomeFirstResponder()
            return false

            
        }
//        else if textField.tag == 101 || textField.tag == 102 || textField.tag == 103 || textField.tag == 104 {
//                        return (textField.text!.length > 0 && range.length == 0) ? false : true
//                    }
        return true
    }
        
//        if ((textField.text?.length)! < 1) && ((string.characters.count ) > 0) {
//            let nextTag: Int = textField.tag + 1
//            var nextResponder: UIResponder? = textField.superview?.viewWithTag(nextTag)
//            if nextResponder == nil {
//                nextResponder = textField.superview?.viewWithTag(1001)
//            }
//            textField.text = string
//            if nextResponder != nil {
//                nextResponder?.becomeFirstResponder()
//            }
//            return false
//        }
//            
//            
//        else  if ((textField.text?.length)! >= 1) || (string.length == 0) {
//            let prevTag: Int = textField.tag - 1
//            // Try to find prev responder
//            var prevResponder: UIResponder? = textField.superview?.viewWithTag(prevTag)
//            if prevResponder == nil {
//                prevResponder = textField.superview?.viewWithTag(1001)
//            }
//            textField.text = string
//            if prevResponder != nil {
//                // Found next responder, so set it.
//                prevResponder?.becomeFirstResponder()
//            }
//            return false
//        }
//        else if textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4 {
//            return (textField.text!.length > 0 && range.length == 0) ? false : true
//        }
//        
//        // upper limit 1
//        return true
        
    
    
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        self.view.layoutIfNeeded()
        switch textField.tag {
        case 100:
            loginInfo.firstTextField = textField.text!
        case 101:
            loginInfo.secondTextField = textField.text!
            
        case 102:
            loginInfo.thirdTextField = textField.text!
            
        default:
            loginInfo.fourthTextField = textField.text!
            
        }
    }
    
    //MARK: - dismissKeyboard function
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    //MARK: - UIButton Actions
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if isAllFieldVarified() {
            
            if isFromProfile {
                self.callApiMethodForVerifyChangeNumber()
                
            } else {
                self.callApiMethodForOtp()
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendOtpButtonAction(_ sender: UIButton) {
        if isFromProfile {
            self.callApiMethodForChangeNumberResendOtp()
        }
        else
        {
            self.callApiMethodForResendOtp()
        }
    }
    //MARK: - Web Service Method
    
    func callApiMethodForOtp() {
       
        let paramDict = [
            KMobileNumber : loginInfo.countryCodes + loginInfo.mobileNumber,
            KVerificationCode : loginInfo.firstTextField + loginInfo.secondTextField + loginInfo.thirdTextField + loginInfo.fourthTextField,
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KOtpVerification, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        if self.isUserRegistered {
                            
                            UserDefaults.standard.set( self.loginInfo.userId, forKey: pUserId)

                            let vcObj = TabBarViewController()
                            self.navigationController?.pushViewController(vcObj, animated: true)
                       
                        } else {
                            let completeVc = CompleteProfileViewController()
                            completeVc.userId = self.loginInfo.userId
                            self.navigationController?.pushViewController(completeVc, animated: true)
                        }
                    
                    } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
                
                }
                
            } else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
        
    }
    
    func callApiMethodForResendOtp() {
        
        let paramDict = [
            KMobileNumber : loginInfo.countryCodes + loginInfo.mobileNumber
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KresendOtp, hudType: .simple) { (result, error, httpCode) in
            
            let response = result as! Dictionary<String, AnyObject>
            
            if error == nil {
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                
                    self.textField1.text = ""
                    self.textField2.text = ""
                    self.textField3.text = ""
                    self.textField4.text = ""
              
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
   
                } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
                
            } else {
                _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
            }
        }
    }
    
  
    func callApiMethodForChangeNumberResendOtp() {
       
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        
        let paramDict = [
            //KMobileNumber : loginInfo.countryCodes + loginInfo.mobileNumber
            KNewMobileNumber :defaults.value(forKey: KNewMobileNumber) as! String,
            KUser_Id        : userId
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KChangeNumberResendOTP, hudType: .simple) { (result, error, httpCode) in
            
            let response = result as! Dictionary<String, AnyObject>
            
            if error == nil {
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                    
                    self.textField1.text = ""
                    self.textField2.text = ""
                    self.textField3.text = ""
                    self.textField4.text = ""
              
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    
                } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
                
            } else {
                _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
            }
        }
    }

    func callApiMethodForVerifyChangeNumber() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId,
            KVerificationCode : loginInfo.firstTextField + loginInfo.secondTextField + loginInfo.thirdTextField + loginInfo.fourthTextField,
            KNewMobileNumber : defaults.value(forKey: KNewMobileNumber) as! String
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KchangeNumberVerify, hudType: .simple) { (result, error, httpCode) in
            
            let response = result as! Dictionary<String, AnyObject>
            
            if error == nil {
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                    _ =     presentAlertWithOptions("", message: response.validatedValue("message", expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                        // pop to settings view controller
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        
                    })
                } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
                
            }else {
                _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
            }
        }
        
    }
    
    
    //MARK:- Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
