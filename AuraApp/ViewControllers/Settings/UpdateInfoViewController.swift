//
//  UpdateInfoViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/16/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import GooglePlaces

class UpdateInfoViewController: UIViewController, UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var updateProfileView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var updateHeaderView: UIView!
    @IBOutlet var updateFooterView: UIView!
    @IBOutlet weak var updateInfoBtn: CustomButton!
    var updateInfoObj = AUserInfo()
    var errorRowNo = Int()
    var imagePicker = UIImagePickerController()

    
    @IBOutlet weak var updateInfoView: UIView!
    
    @IBOutlet weak var updateTableView: UITableView!
    
    //MARK:- UIView LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Methods.
    func initialMethod() {
                
        self.navigationController?.isNavigationBarHidden = true
        self.updateTableView.tableFooterView = updateFooterView
        self.updateTableView.tableHeaderView  = updateHeaderView
        
        self.updateTableView.register(UINib(nibName:"CreateProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateProfileTableViewCell")
        self.callApiMethodToGetProfile()    }
    
  //MARK : - ShadowMethod
    func dropShadow()
   {
    updateProfileView.layer.masksToBounds = false
    updateProfileView.layer.shadowColor = UIColor.gray.cgColor
    updateProfileView.layer.cornerRadius = 5
    updateProfileView.layer.shadowOpacity = 4
    updateProfileView.layer.shadowOffset = CGSize(width: -1 , height: 1)
    updateProfileView.layer.shadowRadius = 5
    profileImageView.layer.shadowPath = UIBezierPath(rect: CGRect(x:0, y:0, width:UIScreen.main.bounds.width + 50, height:64)).cgPath
    updateProfileView.layer.rasterizationScale = UIScreen.main.scale
    }
    
   
    
    //MARK:- UITableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateProfileTableViewCell", for: indexPath) as! CreateProfileTableViewCell
        cell.profileTextfield.delegate = self
        cell.selectionStyle = .none
        cell.profileTextfield.returnKeyType = .next
        cell.profileTextfield.tag = indexPath.row + 100
        cell.profileTextfield.layer.borderWidth = 1
        cell.createProfileButton.isHidden = true
        switch indexPath.row {
            
        case 0:
            cell.profileTextfield.placeholder = "Name"
            cell.profileTextfield.autocapitalizationType = .words
            cell.profileTextfield.text = updateInfoObj.name
            cell.validationMessageLavel.text = (errorRowNo == 100) ? updateInfoObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 100) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            break
        case 1:
            cell.profileTextfield.placeholder = "Email"
            cell.profileTextfield.text = updateInfoObj.email
            cell.validationMessageLavel.text = (errorRowNo == 101) ? updateInfoObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 101) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            cell.profileTextfield.keyboardType = .emailAddress
            break
        case 2:
            cell.profileTextfield.placeholder = "Address(Optional)"
            cell.profileTextfield.text = updateInfoObj.address
            cell.createProfileButton.isHidden = false
            cell.validationMessageLavel.text = (errorRowNo == 102) ? updateInfoObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 102) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            cell.createProfileButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
            cell.profileTextfield.text = updateInfoObj.address
            
            break
        case 3:
            cell.profileTextfield.returnKeyType = .done
            cell.validationMessageLavel.text = (errorRowNo == 103) ? updateInfoObj.strCommonError : ""
            
            cell.profileTextfield.layer.borderColor = (errorRowNo == 103) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            cell.profileTextfield.placeholder = "Status"
            
            cell.profileTextfield.text = updateInfoObj.status
            break
            
        default:
            break
        }
        
        return cell
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) && (textField.tag == 100 || textField.tag == 101 || textField.tag == 102) {
            return false
        }
        else{
            return true
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 100:
            if string.length == 0{
                return true
            }
            if string.isValidName() == true
            {
                if (textField.text?.length)! >= 30 {
                    return false
                }
                return true
            } else {
                return false
            }
        case 101:
            if  (textField.text?.length)! >= 64 || string == " "{
                return false
            }
        case 103:
            if (str.length == 1) &&  (str == "0") {
                return false
            }
            if  (textField.text?.length)! >= 80 && range.length == 0 {
                return false
            }
            
        default:
            break
        }
        return true
    }
    
    //MARK:- UITextField Delegate(updated@26Aug)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateInfoObj.strCommonError = ""
        errorRowNo = 500
        if (updateTableView.indexPathsForVisibleRows?.contains(IndexPath.init(row: textField.tag-100, section: 0)))! {
            let cell: CreateProfileTableViewCell = updateTableView.cellForRow(at: IndexPath.init(row: textField.tag-100, section: 0)) as! CreateProfileTableViewCell
            cell.profileTextfield.layer.borderColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            cell.validationMessageLavel.text = ""
        }
        if textField.tag == 102 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100:
            updateInfoObj.name = textField.text!
            break
        case 101:
            updateInfoObj.email = textField.text!
            break
        case 102:
            updateInfoObj.address = textField.text!
            break
        case 103:
            updateInfoObj.status  = textField.text!
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    func isallFieldVerified() -> Bool {
        var isValid: Bool = false
        if updateInfoObj.name.trimWhiteSpace().length == 0 {
            errorRowNo = 100
            updateInfoObj.strCommonError = BLANK_NAME
            
        }else if updateInfoObj.name.trimWhiteSpace().length <= 1 {
            self.errorRowNo = 100
            updateInfoObj.strCommonError = MINI_NAME
        }else if updateInfoObj.name.isValidName() == false{
            errorRowNo = 100
            updateInfoObj.strCommonError = VALID_NAME
        } else if updateInfoObj.email.trimWhiteSpace().length == 0 {
            errorRowNo = 101
            updateInfoObj.strCommonError = BLANK_EMAIL
            
        }else if updateInfoObj.email.isEmail() == false {
            errorRowNo = 101
            updateInfoObj.strCommonError = VALID_EMAIL
        }else if updateInfoObj.email.trimWhiteSpace().length > 64 {
            errorRowNo = 101
            updateInfoObj.strCommonError = MAX_EMAIL
        } else if updateInfoObj.status.trimWhiteSpace().length == 0 {
            errorRowNo = 103
            updateInfoObj.strCommonError = BLANK_STATUS
        } else {
            isValid = true
        }
        self.updateTableView.reloadData()
        return isValid
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }
    
    
    func openCamera() {
        
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
           
            self.profileImageView.image = image
            updateInfoObj.avatar =  image

            self.updateProfileView.isHidden = false

        } else {
            logInfo("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        updateTableView.reloadData()
        
    }

    //MARK: - UIButton Actions Methods
    
    @IBAction func backButnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated : true)
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as GMSAutocompleteViewControllerDelegate
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func updateInfoBtnAction(_ sender: UIButton) {
        self.view .endEditing(true)
        
        if  isallFieldVerified() {
            self.callApiMethodToUpdateProfile()
        }
    }
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
       
        self.cameraButton.setTitleColor(UIColor.white, for: .normal)
        self.cameraButton.isUserInteractionEnabled = true
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - WebServiceMethod for UpdateProfile
    
    func callApiMethodToGetProfile() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KgetProfile, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if  let response = result as? Dictionary<String,AnyObject> {

                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200  {
                   
                    let dict = response.validatedValue("View_profile_data", expected: NSDictionary())as! Dictionary<String,AnyObject>
                    
                    self.updateInfoObj =  AUserInfo.getDataOfProfile(userInfo: dict)
                    
                    self.profileImageView.sd_setImage(with: self.updateInfoObj.userProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
                    
                    self.updateTableView.reloadData()
                }
                    
                else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
             }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
            
        }
    }
    
    // MARK : - WebServiceMethod for UpdateProfile
    
    func callApiMethodToUpdateProfile() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            Kname : updateInfoObj.name,
            Kemail : updateInfoObj.email,
            Kaddress : updateInfoObj.address,
            KUser_Id : userId,
            KStatus : updateInfoObj.status,
            KprofileImage : "",
            Klongitude : updateInfoObj.longitude,
            Klattitude : updateInfoObj.lattitude
            ] as [String : Any]
            
        var mediaArray = [Dictionary<String, AnyObject>]()
        
        if let avatar = updateInfoObj.avatar {
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
        
        RServiceHelper.multiPart(paramDict, apiName: KupdateInformation, media: mediaArray, showHud: false, isUsingFilePath: false) { (result, error) in
            
            DispatchQueue.main.async {
                hud?.hide(animated: true)
            }
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                            _ =     presentAlertWithOptions("", message: response.validatedValue("message", expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                        
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
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
    extension UpdateInfoViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        updateInfoObj.longitude = place.coordinate.longitude
        updateInfoObj.lattitude = place.coordinate.latitude
        updateInfoObj.address = place.name
        self.updateTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

