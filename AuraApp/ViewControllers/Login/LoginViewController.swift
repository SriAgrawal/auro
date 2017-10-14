//
//  LoginViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 11/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryErrorLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
   
    @IBOutlet weak var countryTextField: CustomTextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!

    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    @IBOutlet weak var mobileNumberTextView: UIView!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    var errorRowNo = Int()
    var countryArray  = [String]()
    var countryCode = [String]()
    var loginInfo = LoginInfo()
    var isFromProfile : Bool = false
    
    //MARK: UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitleLabel()
        addTapGesture()
        getDialingCode()
        initialMethod()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Helper Methods
    
    func setNavigationBarTitleLabel() {
        
        self.navigationTitleLabel.text = (isFromProfile) ? "Change Number" : "Login"
    }
    
    func addTapGesture() {
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func getDialingCode() {
        
        let strBundle: String = Bundle.main.path(forResource: "CountryCodeList", ofType: "csv")!
        let fileObj = try? String(contentsOfFile: strBundle, encoding: String.Encoding.utf8)
        var rows: [String]? = fileObj?.components(separatedBy: "\n")
        rows = rows?.sorted()
        if (rows?.count)! > 1 {
            for row: String in rows! {
                let columns: [Any] = row.components(separatedBy: ",")
                
                if columns.count > 2 {
                    countryArray.append(columns[0] as! String)
                    self.countryCode.append(columns[1] as! String)
                }
            }
        }
    }
    
    func initialMethod() {
        
        self.countryTextField.delegate = self
        self.errorLabel.text = ""
        self.countryErrorLabel.text = ""
        self.mobileNumberTextView.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
        self.mobileNumberTextField.delegate = self
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        doneButton.tag = 3001
        let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
        toolbar.items = itemsArray as? [UIBarButtonItem]
        mobileNumberTextField.inputAccessoryView = toolbar
        mobileNumberTextField.returnKeyType = .done
        
    }
    
    //MARK:- UITextFieldDelegate Methods
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
        if textField.tag == 101 {
          
            view.endEditing(true)
          
            OptionPickerManager().showOptionPickerSelectedIndex(-1, withData: countryArray) { (selectedIndex, selectedItems) in
                
                self.loginInfo.country = (selectedItems?.first as? String)!
                self.countryTextField.text = self.loginInfo.country
                self.countryErrorLabel.text = ""
                self.countryTextField.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
                let indexPath : Int = selectedIndex?.first as! Int
                self.countryCodeLabel.text = "+" + self.countryCode[indexPath]
                self.loginInfo.countryCodes =  "+" + self.countryCode[indexPath]

               // self.countryCodeLabel.text = self.loginInfo.countryCodes

            }
            
            return false
        }
        return true
        
    }
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        if textField.tag == 102
        {
            if (str.length == 1) &&  (str == "0") {
                return false
            }
            if str.length > 15
            {
                return false
            }
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if kWindowWidth <= 320
        {
            
            UIView.animate(withDuration: 1, animations: {
                self.titleTopConstraint.constant = 30
            }, completion: nil)
        }
        
        errorRowNo = 500
        if(textField.tag == 101) {
            self.countryTextField.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            self.countryTextField.text = ""
            self.countryErrorLabel.text = ""
        }
        else if (textField.tag == 102) {
            self.errorLabel.text = ""
            self.mobileNumberTextField.text = ""
            self.mobileNumberTextView.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if kWindowWidth <= 320
        {
            
            UIView.animate(withDuration: 1, animations: {
                self.titleTopConstraint.constant = 65
                
            }, completion: nil)
        }
        
        if textField.tag == 101
        {
            loginInfo.country = textField.text!
        }
        else if textField.tag == 102
        {
            
            loginInfo.mobileNumber = textField.text!
        }
    }
    
    //MARK:- UIButton Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendOtpButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if isAllfieldVarified() {
            
            self.countryErrorLabel.text = ""
            self.countryTextField.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            self.errorLabel.text = ""
            self.mobileNumberTextView.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            if (isFromProfile) {
         
                callApiForChangeNumber()
                
            } else {
                self.callApiMethodForLogin()
            }
            
        } else {
            
            if (errorRowNo == 101) {
                
                self.countryErrorLabel.text = loginInfo.errorString
                self.countryTextField.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
                
            } else if(errorRowNo == 102) {
                
                self.countryErrorLabel.text = ""
                self.countryTextField.layer.borderColor =  UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
                self.errorLabel.text = loginInfo.errorString
                self.mobileNumberTextView.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
            }
        }
    }

    //MARK:- Validation Methods
    
    func isAllfieldVarified() ->Bool {
        
        var isValid = false
        
        if loginInfo.country.trimWhiteSpace().length == 0
        {
            errorRowNo = 101
            loginInfo.errorString = "*Please select country."
            isValid = false
        }
        else if loginInfo.mobileNumber.trimWhiteSpace().length == 0
        {
            errorRowNo = 102
            loginInfo.errorString = "*Please enter mobile number."
            isValid = false
        }
        else if loginInfo.mobileNumber.isValidMobileNumber() == false
        {
            errorRowNo = 102
            
            loginInfo.errorString = "*Please enter valid mobile number."
            isValid = false
        }
        else if loginInfo.mobileNumber.length < 10
        {
            errorRowNo = 102
            
            loginInfo.errorString = "*Please enter atleast 10 digit mobile number."
        }
        else
        {
            isValid = true
        }
        return isValid
    }
  
    //MARK: - dismissKeyboard function
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    //MARK: - WebService Method for login
    
    func callApiMethodForLogin() {
      
        let paramDict = [
            KCountry : loginInfo.country,
            KMobileNumber : loginInfo.countryCodes + loginInfo.mobileNumber,
            Kdevice_token : defaults.value(forKey: pToken) as! String
            ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: Klogin, hudType: .simple) { (result, error, httpCode) in

            if error == nil {
                
                let response = result as! Dictionary<String, AnyObject>

                if Int(response.validatedValue(pStatusCode, expected: NSNumber.self) as! NSNumber) == 200 {
                    
                    let dic = response.validatedValue(KRegister_data, expected: NSDictionary()) as! Dictionary<String, AnyObject>

                    UserDefaults.standard.set(dic.validatedValue(KCountry , expected: "" as AnyObject) as! String, forKey: KCountry)
                    UserDefaults.standard.set(dic.validatedValue(KMobileNumber , expected: "" as AnyObject) as! String, forKey: KMobileNumber)
                
                    self.loginInfo.userId = dic.validatedValue(KId, expected: "" as AnyObject) as! String
                    let vc = OTPViewController()
                    vc.isUserRegistered = dic.validatedValue("mobile_verified", expected: Bool() as AnyObject) as! Bool
                    vc.loginInfo = self.loginInfo
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
            }
            else {
                
             _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
        }
        
    }
    
    func callApiForChangeNumber() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
      
        let paramDict = [
            KUser_Id : userId,
            KCountry : loginInfo.country,
            KNewMobileNumber : loginInfo.countryCodes + loginInfo.mobileNumber,
            Kdevice_token : pToken
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KchangeNumber, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                let response = result as! Dictionary<String, AnyObject>
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                    
                    let dic = response.validatedValue("Data", expected: NSDictionary()) as! Dictionary<String, AnyObject>
                
                    UserDefaults.standard.set(self.loginInfo.countryCodes + self.loginInfo.mobileNumber, forKey: KNewMobileNumber)
                    
                    logInfo(dic.validatedValue(KVerificationCode, expected: "" as AnyObject) as! String)
                
                    let vc = OTPViewController()
                    vc.isFromProfile = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else{
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
        }
        
    }
    
}
