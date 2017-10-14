//
//  NotificationsViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 14/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,toSendResponseBackDelegate {
    
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationInfoArray = [NotificationInfo]()

    var refreshControl: UIRefreshControl!

    //MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMethod()
        
        addNotification()
        
        pullToRefersh()

        setClearAllButtonVisibility()
        
        callApiToGetNotificationList(isPullToRefresh : false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - HelperMethods
    
    func addNotification() {
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.refreshNotificationMethod), name: Notification.Name("refreshNotification"), object: nil)
        
    }
    
    func initialMethod() {
        
        self.notificationTableView.register(UINib(nibName : "NotificationTableViewCell",bundle :nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
        self.notificationTableView.register(UINib(nibName : "NotificationLableTableViewCell",bundle :nil), forCellReuseIdentifier: "NotificationLableTableViewCellId")
        
        self.notificationTableView.estimatedRowHeight = 400

        self.notificationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func setClearAllButtonVisibility() {
        self.clearAllButton.isHidden = (notificationInfoArray.count != 0) ? false : true

    }
    
    func refreshNotificationMethod() {
        callApiToGetNotificationList(isPullToRefresh : false)
    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        notificationTableView.addSubview(refreshControl)
        
    }
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiToGetNotificationList(isPullToRefresh: true)
        
        refreshControl.endRefreshing()
    }
    
    //MARK: - UITableViewDataSource Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath)as! NotificationTableViewCell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NotificationLableTableViewCellId", for: indexPath)as! NotificationLableTableViewCell
        
        let notificationInfo = notificationInfoArray[indexPath.row]
        
        if notificationInfo.notificationType == "Request" {
    
            cell1.acceptButton.buttonIndexPath = indexPath
            cell1.rejectButton.buttonIndexPath = indexPath
            
            cell1.rejectButton.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell1.acceptButton.addTarget(self, action: #selector(notificationAcceptButtonAction(_:)), for: .touchUpInside)
            cell1.rejectButton.addTarget(self, action: #selector(notificationRejectAction(_:)), for: .touchUpInside)
            
            cell1.notificationLabel.text = notificationInfo.notificationMessageString
            cell1.activeTimeLabel.text = notificationInfo.notificationTime
            
            cell1.contactmageView.sd_setImage(with: notificationInfo.profileImage,placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)

            return cell1
            
        } else {

            cell2.notificationLabel.text = notificationInfo.notificationMessageString
            cell2.activeTimeLabel.text = notificationInfo.notificationTime
            
            cell2.contactmageView.sd_setImage(with: notificationInfo.profileImage,placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
            
            return cell2

        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell  = tableView .cellForRow(at: indexPath)!
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "       ") {
            
            (rowAction: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            _ = AlertController.alert("", message: "Are you sure you want to delete?", controller: self, buttons: ["Cancel","OK"], tapBlock: { (UIAlertAction, index) in
                
                if(index == 1) {
                    
                    self.callApiMethodToDeleteNotification(obj:self.notificationInfoArray[indexPath.row])
                }
            })
        }
        
        let img2 = UIImageView(image: UIImage(named: "delete_icon"))
       
        img2.frame = CGRect(x: cell.frame.size.width + 20, y: (cell.frame.size.height / 2) - 15 , width: 40, height: 40)
        img2.contentMode = .scaleAspectFit
        cell.contentView.addSubview(img2)
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    //MARK: - UIButton Actions Methods
    
    @IBAction func notificationAcceptButtonAction(_ sender: NotificationButton) {
        
        let addCategoryVc = CategoryPopUpViewController()
        addCategoryVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addCategoryVc.alertDelegate = self

        let notificationObj = notificationInfoArray[sender.buttonIndexPath.row]
        addCategoryVc.friendId = notificationObj.notificationsenderId
        addCategoryVc.senderName = notificationObj.notificationsenderName
        self.navigationController?.present(addCategoryVc, animated: false, completion: nil)
        
    }
    
    @IBAction func notificationRejectAction(_ sender: NotificationButton) {
        
        _ = AlertController.alert("", message: "Are you sure you want to reject request?", controller:self ,buttons: ["Cancel","Ok"],tapBlock:
            {
                (UIAlertAction,index)in
                if (index == 1) {
                    
                    let notificationObj = self.notificationInfoArray[sender.buttonIndexPath.row]

                    self.callApiMethodToRejectFriendRequest(friendId: notificationObj.notificationsenderId)

                }
        })
        
    }
    
    @IBAction func clearAllButtonAction(_ sender: UIButton) {

        _ = AlertController.alert("", message: "Are you sure you want to delete all notifications?", controller:self ,buttons: ["Cancel","Ok"],tapBlock: {
            
                (UIAlertAction,index)in
            
                if (index == 1) {
                    self.callApiMethodToDeleteAllNotification()

                }
        })
        
    }
    
    //MARK: - Delegate Methods
    
    
    func afterAcceptingFriendRequest(responseMessage: String) {
        
        delay(delay: 0.2) {
            self.callApiToGetNotificationList(isPullToRefresh: false)
            _ = AlertController.alert("", message: responseMessage)
            
        }
    }

    //MARK:- Web Api Methods
    
    func callApiToGetNotificationList(isPullToRefresh : Bool) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KNotificationList, hudType: (isPullToRefresh) ? .smoothProgress : .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.notificationInfoArray = NotificationInfo.getNotificationListArray(responceDict: response )
                        self.notificationTableView.reloadData()
                        
                        self.setClearAllButtonVisibility()
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiMethodToDeleteNotification(obj:NotificationInfo) {

        let paramDict =  ["notification_id" : obj.notificationId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KDeleteSingleNotification, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ =     presentAlertWithOptions("", message: response["message"] as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                            
                            self.callApiToGetNotificationList(isPullToRefresh: false)
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

    func callApiMethodToDeleteAllNotification() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict =  [KUser_Id : userId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KDeleteAllNotification, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.notificationInfoArray.removeAll()
                        self.clearAllButton.isHidden = true
                        self.notificationTableView.reloadData()
                        
                        _ = AlertController.alert("", message: response["message"] as! String)
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                    
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }

    func callApiMethodToRejectFriendRequest(friendId: String) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        let paramDict = [
            KUser_Id : userId,
            KFriendRequestSender :friendId
            ] as [String : Any]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KRejectFriendRequest, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                let response = result as! Dictionary<String, AnyObject>
                
                if Int(response.validatedValue(pStatusCode, expected: NSNumber.self) as! NSNumber) == 200 {
                  
                    _ =     presentAlertWithOptions("", message: response["message"] as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                        
                        self.callApiToGetNotificationList(isPullToRefresh: false)
                    })
                
                }
                else{
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
            }
            else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")   }
        }
    }

}
