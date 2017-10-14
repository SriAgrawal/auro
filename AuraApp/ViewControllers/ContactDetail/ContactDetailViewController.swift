//
//  ContactDetailViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 22/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,customAlertDelegateCategory {
    
    @IBOutlet weak var showLocationUnderLineLabel: UILabel!
    @IBOutlet weak var showLocationLabel: UILabel!
    @IBOutlet weak var noSharingUnderLineLabel: UILabel!
    @IBOutlet weak var addFriendUnderLineLabel: UILabel!
    @IBOutlet weak var notificationUnderLineLabel: UILabel!
    @IBOutlet weak var locationUnderlineLabel: UILabel!
    @IBOutlet weak var mobileNoSharingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addFriendLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    @IBOutlet weak var showLocationButton: UIButton!
    @IBOutlet weak var numberShareButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var contactBarView: UIView!
    @IBOutlet var contactHeaderView: UIView!

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactDetailTableView: UITableView!
    
    var homeInfoObj = HomeInfo()
    
    var contactId : String = ""
    
    var refreshControl: UIRefreshControl!

    //MARK: - UIViewControllerLifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialMethod()
        
        callApiMethodToViewContactProfile(isPullToRefresh: false)
        
        pullToRefersh()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Helper Methods
    
    func initialMethod() {
        
        categoryButton.isHidden = true
        
        self.showLocationUnderLineLabel.isHidden = true
        self.locationUnderlineLabel.isHidden = true
        self.notificationUnderLineLabel.isHidden = true
        self.addFriendUnderLineLabel.isHidden = true
        self.noSharingUnderLineLabel.isHidden = true
        self.showLocationUnderLineLabel.isHidden = true
        
        self.contactBarView.layer.borderColor = UIColor.lightGray.cgColor
        self.contactDetailTableView.tableHeaderView = contactHeaderView
        self.contactDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.none
       
        self.contactDetailTableView.register(UINib(nibName:"HomeTableViewCell",bundle : nil), forCellReuseIdentifier: "HomeTableViewCell" )
        
        self.contactDetailTableView.estimatedRowHeight = 400
        
    }
    
    func setData() {
     
        contactImageView.sd_setImage(with: homeInfoObj.userProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
        contactName.text = homeInfoObj.userNameString
        mobileNumberLabel.text = homeInfoObj.userMobileNumber

    }
    
    func setFriendUnfriendButtonData() {
        
        if homeInfoObj.friendStatus {
            categoryButton.isHidden = false
            self.addFriendLabel.text = "Unfriend"
            self.addFriendButton.setImage(UIImage(named:"add_icon"), for: .normal)
            
        } else {
            categoryButton.isHidden = true
            self.addFriendLabel.text = "Add Friend"
            self.addFriendButton.setImage(UIImage(named:"unfriend_icon"), for: .normal)
            
        }
        
        self.buttonChange(addFriendButton, label: self.addFriendLabel, underlineLabel: self.addFriendUnderLineLabel)

    }
    
    func setNotificationButtonData() {
        
        self.notificationLabel.text = (homeInfoObj.notificationOnOffStatus) ? "Notification On" : "Notification Off"
        
    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        contactDetailTableView.addSubview(refreshControl)
        
    }
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiMethodToViewContactProfile(isPullToRefresh: true)
        
        refreshControl.endRefreshing()
    }
    
    //MARK: - UITableViewDataSorce Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return self.homeInfoObj.friendPostArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)as! HomeTableViewCell
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
        
        cell.commentButton.tag = indexPath.row+100
        cell.showPhotoButton.tag = indexPath.row
        
        //cell.commentButton.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        cell.showPhotoButton.addTarget(self, action: #selector(showPhotoSelectorMethod(_:)), for: .touchUpInside)

        let obj = self.homeInfoObj.friendPostArray[indexPath.row]
      
        cell.friendsNameLabel.text = obj.friendNameString
        cell.friendsStatus.text = obj.friendStatusString
        cell.commentLabel.text  = (obj.numberOfComment > 1) ? "\(obj.numberOfComment)" + " comments" : "\(obj.numberOfComment)" + " comment"
        
        cell.activeTimeLabel.text = obj.activeTimeString
        
        cell.profileImageView.sd_setImage(with: obj.friendProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
        cell.postPhotoImageView.sd_setImage(with: obj.statusImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let commentVc = CommentViewController()
        commentVc.homeInfoObj = self.homeInfoObj.friendPostArray[indexPath.row]
       
        self.navigationController?.pushViewController(commentVc, animated: true)

    }
    
    //   MARK: - Custom Method for change states of buttons
    
    @IBAction func showPhotoSelectorMethod(_ sender: UIButton) {
        
        let path = IndexPath(row:sender.tag, section: 0)
        let cell =  self.contactDetailTableView.cellForRow(at: path) as! HomeTableViewCell
        
        EXPhotoViewer.showImage(from: cell.postPhotoImageView)
        
    }
    
    func buttonChange(_ sender: UIButton, label: UILabel, underlineLabel: UILabel) {
        
        self.locationUnderlineLabel.isHidden = true
        self.notificationUnderLineLabel.isHidden = true
        self.addFriendUnderLineLabel.isHidden = true
        self.noSharingUnderLineLabel.isHidden = true
        self.showLocationUnderLineLabel.isHidden = true
        numberShareButton.isSelected = false
        addFriendButton.isSelected = false
        locationButton.isSelected = false
        notificationButton.isSelected = false
        showLocationButton.isSelected = false
        self.addFriendLabel.textColor = UIColor.black
        self.notificationLabel.textColor = UIColor.black
        self.locationLabel.textColor = UIColor.black
        self.mobileNoSharingLabel.textColor = UIColor.black
        self.showLocationLabel.textColor = UIColor.black
        
        sender.isSelected = true
        underlineLabel.isHidden = false
        if(sender.isSelected == true)
        {
            label.textColor = UIColor.init(red: 7.0/255.0, green: 201.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        }
    }
    
    func checkFriendSatus() -> Bool{
        
        if !homeInfoObj.friendStatus {
            _ = AlertController.alert("", message: "Please add this user as your friend first.")
            
            return false
        }
        
        return true
    }
    
    //MARK: - UIButton action methods
    
    @IBAction func commentButtonAction(_ sender: UIButton)  {
        
    }
    
    @IBAction func mobileNoSharing(_ sender: UIButton) {
        
        self.buttonChange(numberShareButton, label: self.mobileNoSharingLabel, underlineLabel: self.noSharingUnderLineLabel)
        
        if checkFriendSatus() {
            
            DispatchQueue.main.async {
                
                    let alertLabelVC = AlertPopUpViewController(nibName: "AlertPopUpViewController", bundle: nil)
                    alertLabelVC.showCommonPopup(with: { (Int) in
                        
                        if (Int == 1) {
                            
                            self.callApiMethodToShareMobileDetails()
                        }
                        
                    }, labelTitle: "Do you want to share your phone contact details with " +  self.homeInfoObj.userNameString + "?")
            }
        }
    
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
        
        self.buttonChange(locationButton, label: self.locationLabel, underlineLabel: self.locationUnderlineLabel)
        
        if checkFriendSatus() {

            DispatchQueue.main.async {
                
                let alertLabelVC = AlertPopUpViewController(nibName: "AlertPopUpViewController", bundle: nil)
                alertLabelVC.showCommonPopup(with: { (Int) in
                    
                    if (Int == 1) {
                        
                        self.callApiMethodToShareLocation()
                    }
                    
                }, labelTitle: "Are you sure you want to share your location with this user?")
            }
        }
        
    }
    
    @IBAction func AddFriendButtonAction(_ sender: UIButton) {
        
        self.buttonChange(addFriendButton, label: self.addFriendLabel, underlineLabel: self.addFriendUnderLineLabel)
       
            DispatchQueue.main.async  {
                
                    let alertLabelVC = AlertPopUpViewController(nibName: "AlertPopUpViewController", bundle: nil)
                    alertLabelVC.showCommonPopup(with: { (Int) in
                        
                        if (Int == 1) {
                            
                            (self.homeInfoObj.friendStatus) ? self.callApiMethodToUnfriendFriend() : self.callApiMethodToAddFriend()
                        }
                        
                    }, labelTitle: (self.homeInfoObj.friendStatus) ? "Are you sure you want to unfriend?" : "Are you sure you want to sent friend request?")
            }
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        
        self.buttonChange(notificationButton, label: self.notificationLabel, underlineLabel: self.notificationUnderLineLabel)
        
        if checkFriendSatus() {

            DispatchQueue.main.async {
                
                    let alertLabelVC = AlertPopUpViewController(nibName: "AlertPopUpViewController", bundle: nil)
                    alertLabelVC.showCommonPopup(with: { (Int) in
                        
                        if (Int == 1) {
                            
                            self.callApiMethodToTurnOnOffNotification()
                        }
                        
                    }, labelTitle: (self.homeInfoObj.notificationOnOffStatus) ? "Are you sure you want to turn off notification?" : "Are you sure you want to turn on notification?")
           
            }

        }
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showLocationButtonAction(_ sender: UIButton) {
        
        if checkFriendSatus() {

            self.buttonChange(showLocationButton, label: self.showLocationLabel, underlineLabel:self.showLocationUnderLineLabel)
            
            let locationVc = MapViewController()
            locationVc.friendIdString = contactId
            locationVc.friendName = self.homeInfoObj.userNameString
            
            self.navigationController?.pushViewController(locationVc, animated: true)
        }
       
    }
    
    @IBAction func categoryButtonAction(_ sender: UIButton) {
        
        let categoryVc = ChooseAccountViewController(nibName: "ChooseAccountViewController", bundle: nil)
        categoryVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        categoryVc.alertDelegate = self
        categoryVc.friendId = contactId
        self.navigationController?.present(categoryVc, animated: false, completion: nil)        
        
    }
    
    func alertCompletetion() {
        let vcObj = AddProfileViewController()
        self.navigationController?.pushViewController(vcObj, animated: false)
    }
    
    func afterAddingCategory(responseMessage: String) {

        delay(delay: 0.2) {
            _ = AlertController.alert("", message: responseMessage)

        }
    }
    
    // MARK: - Web Api Method
    
    func callApiMethodToViewContactProfile(isPullToRefresh: Bool) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId,
                         KFriendId : contactId]

        ServiceHelper.request(params: paramDict, method: .post, apiName: KViewContactProfile, hudType: (isPullToRefresh) ? .smoothProgress : .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.homeInfoObj = HomeInfo.getConatctProfileArray(responceDict: response)
                        
                        self.setData()
                        self.setFriendUnfriendButtonData()
                        self.setNotificationButtonData()
                        self.contactDetailTableView.reloadData()
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiMethodToAddFriend() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = ["friend_request_sender" : userId,
                         "friend_request_receiver" : contactId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KAddFriend, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)

                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiMethodToUnfriendFriend() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = ["friend_request_sender" : userId,
                         "friend_request_receiver" : contactId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KUnfriend, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                        self.homeInfoObj.friendStatus = false
                        self.homeInfoObj.notificationOnOffStatus = false

                        self.setFriendUnfriendButtonData()
                        self.setNotificationButtonData()

                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }

    func callApiMethodToShareLocation() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId,
                         "friend_id" : contactId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KShareLocation, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiMethodToShareMobileDetails() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = ["contact_sender" : userId,
                         "contact_receiver" : contactId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KContactsShare , hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiMethodToTurnOnOffNotification() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId,
                         "friend_id" : contactId,
                         "status" : !self.homeInfoObj.notificationOnOffStatus] as [String : Any]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KNotificationStatus , hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        if (self.homeInfoObj.notificationOnOffStatus) {
                            _ = AlertController.alert("", message: "Notification turn off successfully.")

                        } else {
                            _ = AlertController.alert("", message: "Notification turn on successfully.")

                        }
                        
                        self.homeInfoObj.notificationOnOffStatus = !self.homeInfoObj.notificationOnOffStatus
                        self.setNotificationButtonData()
                        
//                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                        
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
