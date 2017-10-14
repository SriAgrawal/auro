//
//  CompleteProfileViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/11/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class CompleteProfileViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    var profileObj = AUserInfo()
    var errorRowNo = Int()
    var imagePicker =  UIImagePickerController()

    var userId = ""
    
    @IBOutlet var profileFooterView: UIView!
    @IBOutlet weak var ProfileTableView: UITableView!
   
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var profileHeaderView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    
    @IBOutlet weak var profileButton: UIButton!

    //MARK:- UIView LifeCycle Method
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.customInit()
        self.dropShadow()
    }
    
    //MARK: - Helper Methods.
    
    func customInit() {
      
        self.ProfileTableView.tableHeaderView = profileHeaderView
        self.ProfileTableView.tableFooterView = profileFooterView
        let nib = UINib(nibName: "CreateProfileTableViewCell", bundle: nil)
        ProfileTableView.register(nib, forCellReuseIdentifier: "CreateProfileTableViewCell")
        ProfileTableView.estimatedRowHeight = 84
        ProfileTableView.rowHeight = UITableViewAutomaticDimension
        errorRowNo = 500
        self.editProfileView.isHidden = true
    }
   
    func dropShadow() {
        
        profileView.layer.masksToBounds = false
        profileView.layer.shadowColor = UIColor.gray.cgColor
        profileView.layer.shadowOpacity = 0.3
        profileView.layer.shadowOffset = CGSize(width: -1 , height: 1)
        profileView.layer.shadowRadius = 10
        profileView.layer.shadowPath = UIBezierPath(rect: CGRect(x:0, y:0, width:UIScreen.main.bounds.width + 50, height:64)).cgPath
        profileView.layer.shouldRasterize = true
        profileView.layer.rasterizationScale = UIScreen.main.scale
        
        editProfileView.layer.masksToBounds = false
        editProfileView.layer.shadowColor = UIColor.gray.cgColor
        editProfileView.layer.cornerRadius = 5
        editProfileView.layer.shadowOpacity = 4
        editProfileView.layer.shadowOffset = CGSize(width: -1 , height: 1)
        editProfileView.layer.shadowRadius = 5
        profileImageView.layer.shadowPath = UIBezierPath(rect: CGRect(x:0, y:0, width:UIScreen.main.bounds.width + 50, height:64)).cgPath
        editProfileView.layer.rasterizationScale = UIScreen.main.scale
        
        
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
               print(error)
            
            } else if let address = placemarks?.first?.name,
               
                let country = placemarks?.first?.country,
                
                let city = placemarks?.first?.locality {
                
                let completeAddress = ("\(address)"+",\(city)"+",\(country)")
                completion(completeAddress, city)
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
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
        cell.createProfileButton.isHidden = true
        
        switch indexPath.row {
       
        case 0:
            cell.profileTextfield.placeholder = "Name"
            cell.profileTextfield.autocapitalizationType = .words
            cell.profileTextfield.text = profileObj.name
            cell.validationMessageLavel.text = (errorRowNo == 100) ? profileObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 100) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            cell.profileTextfield.layer.borderWidth = 1
       
        case 1:
            cell.profileTextfield.placeholder = "Email"
            cell.profileTextfield.text = profileObj.email
            cell.validationMessageLavel.text = (errorRowNo == 101) ? profileObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 101) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            cell.profileTextfield.layer.borderWidth = 1
            cell.profileTextfield.keyboardType = .emailAddress
        
        case 2:
            cell.profileTextfield.placeholder = "Status"
            cell.profileTextfield.autocapitalizationType = .sentences
            cell.profileTextfield.text = profileObj.status
            
            cell.validationMessageLavel.text = (errorRowNo == 102) ? profileObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 102) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            cell.profileTextfield.layer.borderWidth = 1
       
        default:
            
            var myMutableStringTitle = NSMutableAttributedString()
            cell.profileTextfield.returnKeyType = .done

            let Name  = "Address(optional)" // PlaceHolderText
            myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 14.0)!]) // Font
            myMutableStringTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range:NSRange.init(location: 7, length: Name.characters.count-7))    // Color
           
            cell.profileTextfield.attributedPlaceholder = myMutableStringTitle
            cell.validationMessageLavel.text = (errorRowNo == 103) ? profileObj.strCommonError : ""
            cell.profileTextfield.layer.borderColor = (errorRowNo == 103) ?  UIColor.init(red: 255.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor : UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            cell.profileTextfield.layer.borderWidth = 1
            cell.profileTextfield.text = profileObj.address
           
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    //MARK:- UITextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) && (textField.tag == 100 || textField.tag == 101 || textField.tag == 103) {
            return false
        }
        else{
            return true
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        if string.length == 0 {
            return true
        }
        switch textField.tag {
        case 100:
            
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
        case 102:
            if  (textField.text?.length)! >= 80 || string == ""{
                return false
            }
        default:
            break
        }
        return true
    }
    //MARK:- UITextField Delegate(updated@26Aug)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        profileObj.strCommonError = ""
        errorRowNo = 500
        if (ProfileTableView.indexPathsForVisibleRows?.contains(IndexPath.init(row: textField.tag-100, section: 0)))! {
            let cell: CreateProfileTableViewCell = ProfileTableView.cellForRow(at: IndexPath.init(row: textField.tag-100, section: 0)) as! CreateProfileTableViewCell
            cell.profileTextfield.layer.borderColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
            
            // cell.profileTextfield.layer.borderColor = UIColor.green.cgColor
            
            cell.validationMessageLavel.text = ""
            
            if textField.tag == 103 {
                let autocompleteController = GMSAutocompleteViewController()
                autocompleteController.delegate = self as! GMSAutocompleteViewControllerDelegate
                present(autocompleteController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100:
            profileObj.name = textField.text!
            break
        case 101:
            profileObj.email = textField.text!
            break
        case 102:
            profileObj.status = textField.text!
        case 103:
            profileObj.address = textField.text!
            break
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
       
        if profileObj.name.trimWhiteSpace().length == 0 {
            errorRowNo = 100
            profileObj.strCommonError = BLANK_NAME
            
        } else if profileObj.name.trimWhiteSpace().length <= 1 {
            errorRowNo = 100
            profileObj.strCommonError = MINI_NAME
        
        } else if profileObj.name.isValidName() == false{
            errorRowNo = 100
            profileObj.strCommonError = VALID_NAME
        
        } else if profileObj.email.trimWhiteSpace().length == 0 {
            errorRowNo = 101
            profileObj.strCommonError = BLANK_EMAIL
            
        } else if profileObj.email.isEmail() == false {
            errorRowNo = 101
            profileObj.strCommonError = VALID_EMAIL
        
        } else if profileObj.email.trimWhiteSpace().length > 64 {
            errorRowNo = 101
            profileObj.strCommonError = MAX_EMAIL
        
        } else if profileObj.status.trimWhiteSpace().length == 0 {
            errorRowNo = 102
            profileObj.strCommonError = BLANK_STATUS
            
        } else {
            isValid = true
        }
        
        self.ProfileTableView.reloadData()
        return isValid
        
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
            self.editProfileView.isHidden = false
            profileObj.avatar =  image
       
        } else {
            logInfo("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        ProfileTableView.reloadData()
        
    }
    
    //MARK:- UIButton Action Methods
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
       
        if  isallFieldVerified() {
           self.callApiMethodForCompleteProfile()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func currentLocationAction(_ sender: UIButton) {
        
        self.view.endEditing(true)        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                
            case .notDetermined, .restricted, .denied :
                
                
                _ = AlertController.alert("", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settings.", controller:self ,buttons: ["Ok","Cancel"],tapBlock:
                    {
                        (UIAlertAction,index)in
                        if (index == 0)
                        {
                            let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION")
                            UIApplication.shared.openURL(url!)
                        }
                })

            case .authorizedAlways, .authorizedWhenInUse:
                
                let location = CLLocation(latitude: kAppDelegate.currentLatitude, longitude: kAppDelegate.currentLongitude)
                
                fetchCountryAndCity(location: location) { country, city in
                    
                    self.profileObj.lattitude = kAppDelegate.currentLatitude
                    self.profileObj.longitude = kAppDelegate.currentLongitude
                    self.profileObj.address = country
                    self.ProfileTableView.reloadData()
                }            }
        } else {
            logInfo("Location services are not enabled")
        }

    }
        
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
       
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        self.profileButton.setTitleColor(UIColor.white, for: .normal)
        self.profileButton.isUserInteractionEnabled = true
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
    
    //MARK: - WebService Method
    
    func callApiMethodForCompleteProfile() {
        
        let paramDict = [
            KUser_Id : self.userId,
            Kname : profileObj.name,
            KprofileImage : "",
            Kemail : profileObj.email,
            Kaddress : profileObj.address,
            KStatus : profileObj.status,
            Klongitude : profileObj.longitude,
            Klattitude : profileObj.lattitude
           ] as [String : Any]
        
        var mediaArray = [Dictionary<String, AnyObject>]()
        
        if let avatar = profileObj.avatar {
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

        RServiceHelper.multiPart(paramDict, apiName: KcompleteProfile, media: mediaArray, showHud: false, isUsingFilePath: false) { (result, error) in
            
            DispatchQueue.main.async {
                hud?.hide(animated: true)
            }
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        let dic = response.validatedValue(KProfile_data, expected: NSDictionary()) as! Dictionary<String, AnyObject>
                        
                        UserDefaults.standard.set( dic.validatedValue(KUser_Id, expected: "" as AnyObject), forKey: pUserId)

                        UserDefaults.standard.set(true, forKey: pIsProfileComplete)
                        
                        let vcObj = TabBarViewController()
                        self.navigationController?.pushViewController(vcObj, animated: true)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
        
    }
        
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- GMSAutcomplete Methods

extension CompleteProfileViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //  print("Place name: \(place.name)")
        
        profileObj.longitude = place.coordinate.longitude
        profileObj.lattitude = place.coordinate.latitude
        profileObj.address = place.name
        ProfileTableView.reloadData()
        
        // print("Place address: \(place.formattedAddress)")
        //  print("Place attributions: \(place.attributions)")
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




