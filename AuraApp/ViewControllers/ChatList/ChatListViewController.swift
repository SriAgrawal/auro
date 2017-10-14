//
//  ChatListViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 14/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chatListTableView: UITableView!
    
    var chatInfoArray = [ChatInfo]()
    var isContact = Bool()
    
    var refreshControl: UIRefreshControl!

    //MARK: - UIViewController LifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
        callApiToGetChatList(isPullToRefresh:false)
        pullToRefersh()

    }

    //MARK: - Helper Method
    
    func initialMethod() {
        
        self.backButton.isHidden = true
       
        if(isContact) {
            self.backButton.isHidden = false
        }
        
        self.chatListTableView.estimatedRowHeight = 400
        self.chatListTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil),forCellReuseIdentifier: "ContactTableViewCell")
        self.chatListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        chatListTableView.addSubview(refreshControl)
        
    }
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiToGetChatList(isPullToRefresh:true)
        
        refreshControl.endRefreshing()
    }
    
    //MARK:- UIButton Action Methods
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
    //MARK: - UITableViewDataSource Methods
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)as! ContactTableViewCell
       
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let chatInfo = chatInfoArray[indexPath.row]
        cell.contactTitleLabel.text = chatInfo.recieverName
        cell.contactImageView.sd_setImage(with: chatInfo.recieverImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)

        cell.contactNameLabel.text = (chatInfo.messageType == "text") ? chatInfo.lastMessageString : "image"
        cell.contactNameLabel.textColor = (chatInfo.messageType == "text") ? UIColor.black : UIColor.lightGray
        
        cell.timeDateLabel.text = chatInfo.chatDateTimeString

        
        cell.callButton.isHidden = true
        cell.chatButton.isHidden =  true
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatVc = ChatViewController()
        chatVc.contactId = chatInfoArray[indexPath.row].recieverId
        chatVc.recieverName = chatInfoArray[indexPath.row].recieverName
        chatVc.recieverImageProfile = chatInfoArray[indexPath.row].recieverImage
        
        self.navigationController?.pushViewController(chatVc, animated: true)
                
    }
    
    //MARK:- Web Api Methods
    
    func callApiToGetChatList(isPullToRefresh:Bool) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KChatList, hudType: (isPullToRefresh) ? .smoothProgress: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.chatInfoArray = ChatInfo.getChatListArray(responceDict: response)
                        
                        self.chatListTableView.reloadData()
                        
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
