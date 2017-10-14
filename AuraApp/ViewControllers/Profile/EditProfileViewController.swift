//
//  EditProfileViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/17/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate,doneButtonDelegate {
    var navigationBarTitle:String?
    var imagePicker =  UIImagePickerController()
    var base64Str = NSString()
    var editObj = AUserInfo()
    var dataSourceArray = NSMutableArray()
    var errorRowNo = Int()
    var checkProfile = false
    var selectedContact = NSMutableArray()
    
    @IBOutlet weak var myProfileView: UIView!
    @IBOutlet weak var editTitleLabel: UILabel!
    @IBOutlet weak var editDoneButton: CustomButton!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet var editProfileFooterView: UIView!
    @IBOutlet var editProfileHeaderView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var editProfileTableView: UITableView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var editImageView: UIImageView!
    
    //MARK: - UIViewController LifeCycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        self.dropShadow()
    }
    
    func initialMethod() {
     
        self.editProfileTableView.tableHeaderView = editProfileHeaderView
        self.editProfileTableView.tableFooterView = editProfileFooterView
        addContactButton.layer.cornerRadius = addContactButton.frame.size.height / 2
        addContactButton.layer.borderColor = UIColor.init(red: 56.0/255.0, green: 198.0/255.0, blue: 195.0/255.0, alpha: 1.0).cgColor
        addContactButton.layer.borderWidth = 2
        self.dataSourceArray.add(editObj)
       
        // For registereing nib
        let nib = UINib(nibName: "CreateProfileTableViewCell", bundle: nil)
        editProfileTableView.register(nib, forCellReuseIdentifier: "CreateProfileTableViewCell")
        let newNib = UINib(nibName: "MyProfileTableViewCell", bundle: nil)
        editProfileTableView.register(newNib, forCellReuseIdentifier: "MyProfileTableViewCell")
        self.myProfileView.isHidden = true
        
    }
    func dropShadow() {
        
        editProfileView.layer.masksToBounds = false
        editProfileView.layer.shadowColor = UIColor.gray.cgColor
        editProfileView.layer.shadowOpacity = 0.3
        editProfileView.layer.shadowOffset = CGSize(width: -1 , height: 1)
        editProfileView.layer.shadowRadius = 10
        editProfileView.layer.shadowPath = UIBezierPath(rect: CGRect(x:0, y:0, width:UIScreen.main.bounds.width + 50, height:64)).cgPath
        myProfileView.layer.shouldRasterize = true
        myProfileView.layer.rasterizationScale = UIScreen.main.scale
        myProfileView.layer.masksToBounds = false
        myProfileView.layer.shadowColor = UIColor.gray.cgColor
        myProfileView.layer.cornerRadius = 5
        myProfileView.layer.shadowOpacity = 4
        myProfileView.layer.shadowOffset = CGSize(width: -1 , height: 1)
        myProfileView.layer.shadowRadius = 5
     
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - table view delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if checkProfile == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateProfileTableViewCell") as? CreateProfileTableViewCell
            cell?.createProfileButton.isHidden = true
            cell?.profileTextfield.isUserInteractionEnabled = true
            self.editDoneButton.isUserInteractionEnabled = true
            cell?.profileTextfield.delegate = self
            cell?.profileTextfield.tag = indexPath.row + 100
            
            cell?.profileTextfield.autocapitalizationType = .words
            cell?.profileTextfield.returnKeyType = .next
            cell?.createProfileButton.isHidden = true
            //        cell?.profileTextField.isUserInteractionEnabled = true
            cell?.selectionStyle = .none
            switch indexPath.row {
            case 0:
                cell?.profileTextfield.placeholder = "Profile Name"
               // cell?.profileTextfield.text=editObj.name
                cell?.validationMessageLavel.text = (errorRowNo == 100) ? editObj.strCommonError : ""
                cell?.profileTextfield.layer.borderColor = (errorRowNo == 100) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
                cell?.profileTextfield.layer.borderWidth = 1
                
                break
            case 1:
                cell?.profileTextfield.returnKeyType = .done
                cell?.profileTextfield.placeholder = "Status"
                cell?.validationMessageLavel.text = (errorRowNo == 101) ? editObj.strCommonError : ""
                cell?.profileTextfield.layer.borderColor = (errorRowNo == 101) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
                cell?.profileTextfield.layer.borderWidth = 1
               // cell?.profileTextfield.text=editObj.status
                break
            default:
                break
            }
            return cell!
        }
        else {
            
            let myProfileCell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell")as? MyProfileTableViewCell
            myProfileCell?.editProfileClick.addTarget(self, action: #selector(buttonTap), for: UIControlEvents.touchUpInside)
            myProfileCell?.profileNameTextField.isUserInteractionEnabled = false
            myProfileCell?.selectionStyle = .none
            self.editDoneButton.isUserInteractionEnabled = false
            switch indexPath.row {
            case 0:
                myProfileCell?.profileNameTextField.placeholder = "Profile Name"
               // myProfileCell?.profileNameTextField.text=editObj.name
                
                break
            case 1:
                myProfileCell?.profileNameTextField.placeholder = "Status"
               // myProfileCell?.profileNameTextField.text=editObj.status
                break
            default:
                break
            }
            return myProfileCell!
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if checkProfile == false {
            return 45
        } else {
            return 60
        }
        
    }
    
    
    //MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) && (textField.tag == 100) {
            return false
        }
        else{
            return true
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        if string.length == 0
        {
            return true
        }
        if string.containsAlphabetsOnly() == false {
            return false
        }
        switch textField.tag {
        case 100:
            if (textField.text?.length)! >= 30 || string.length == 0 {
                return false
            }
        default:
            break
        }
        return true
    }
    
    //MARK:- UITextField Delegate(updated@26Aug)
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next
        {
            if(textField.tag == 101){
                self.editProfileTableView .viewWithTag(103)?.becomeFirstResponder()
            }
            self.editProfileTableView .viewWithTag(textField.tag+1)?.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 100 {
            editObj.strCommonError = " "
            
        }else if textField.tag == 101 {
        }
        errorRowNo = 500
        if (editProfileTableView.indexPathsForVisibleRows?.contains(IndexPath.init(row: textField.tag-100, section: 0)))! {
            let cell: CreateProfileTableViewCell = editProfileTableView.cellForRow(at: IndexPath.init(row: textField.tag-100, section: 0)) as! CreateProfileTableViewCell
            cell.profileTextfield.layer.borderColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            cell.validationMessageLavel.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view .layoutIfNeeded()
        
        switch textField.tag {
        case 100:
            editObj.name = textField.text!
            break
        case 101:
            editObj.status = textField.text!
            
        default:
            break
        }
    }
    
    func isallFieldVerified() -> Bool {
        var isValid: Bool = false
        if editObj.name.trimWhiteSpace().length == 0 {
            errorRowNo = 100
            editObj.strCommonError = BLANK_NAME
            
        }else if editObj.name.trimWhiteSpace().length < 2 {
            errorRowNo = 100
            editObj.strCommonError = MINI_NAME
        } else if editObj.name.isValidName() == false{
            errorRowNo = 100
            editObj.strCommonError = VALID_NAME
        } else {
            isValid = true
        }
        self.editProfileTableView.reloadData()
        return isValid
        
    }
    
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        self.editProfileButton.setTitleColor(UIColor.white, for: .normal)
        self.editProfileButton.isUserInteractionEnabled = true
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose an Action", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.editImageView.image = image
            editObj.avatar = image
            
            self.myProfileView.isHidden = false

        } else {
            logInfo("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        editProfileTableView.reloadData()
    }
    
    @IBAction func editDoneBtnAction(_ sender: UIButton) {
        if checkProfile == false {
            //self.callApiMethodForAddMultipleProfile()
            self.editProfileButton.addTarget(self, action: #selector(buttonTap), for: UIControlEvents.touchUpInside)
            self.editProfileTableView.reloadData()
            
        } else {
            if isallFieldVerified() {
                self.callApiMethodForAddMultipleProfile()
                self.checkProfile = false
                self.editTitleLabel.text = "Profile"
                self.editDoneButton.setTitle("Save", for: UIControlState.normal)
                
            }
            self.editProfileTableView.reloadData()
        }
    }
    
    
    @IBAction func addContactBtnAction(_ sender: UIButton) {
        
        let contactVc = ContactViewController()
         contactVc.isCheckBox = true
         contactVc.doneButtonDelegate = self
        self.navigationController?.pushViewController(contactVc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        if checkProfile == true{
            checkProfile = false
            self.editTitleLabel.text = "Profile"
            self.editDoneButton.setTitle("Save", for: UIControlState.normal)
            self.editProfileTableView.reloadData()
        } else {
            checkProfile = true
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    //MARK : - CustomDelegateMethods
    func doneButtonAction(selectedContacts : NSMutableArray){
     self.selectedContact = selectedContacts
    }
    
    //MARK: - UIButton Selector Method
    
    @IBAction func buttonTap(sender: AnyObject) {
        checkProfile = true
        self.view .endEditing(true)
        self.editTitleLabel.text = "Edit Profile"
        self.editDoneButton.setTitle("Done", for: UIControlState.normal)
        self.editProfileTableView.reloadData()
    
    }
    
    //MARK: - WebServiceMethod for UploadPhoto

    func callApiMethodForAddMultipleProfile() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId,
            KprofileImage : "",
            "status" : editObj.status,
            KprofileType : editObj.name,
            "profile_type_contacts" : selectedContact
            ] as [String : Any]
        
        var mediaArray = [Dictionary<String, AnyObject>]()
        
        if let avatar = editObj.avatar {
            let mediaInfoDict = [
                keyMultiPartData : avatar.toData(),
                keyMultiPartFileType : multiPartFileTypeImage,
                keyMultiPartKeyAtServerSide : KprofileImage
                ] as [String : AnyObject]
            
            mediaArray.append(mediaInfoDict)
        }

        var hud = MBProgressHUD(for: kAppDelegate.window!)
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
        }
        
        hud?.show(animated: true)
        
        RServiceHelper.multiPart(paramDict, apiName: KCreateMultipleProfile, media: mediaArray, showHud: false, isUsingFilePath: false) { (result, error) in
            
            DispatchQueue.main.async {
                hud?.hide(animated: true)
            }
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                            _ =     presentAlertWithOptions("", message: response.validatedValue("message",     expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                        
                            _ =    self.navigationController?.popViewController(animated: true)
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
    
    //MARK:- Memory management methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
