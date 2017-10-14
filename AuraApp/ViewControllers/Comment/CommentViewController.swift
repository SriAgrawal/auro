//
//  CommentViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
protocol refreshpostDelegate{
    func toRefreshMyPost()
}


class CommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var commentDelegate : refreshpostDelegate?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageSendTextView: UITextView!
  
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet var headerView: UIView!
  
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var statusStringLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var textViewPlaceholderlabel: UILabel!

    @IBOutlet weak var showPhotoButton: UIButton!
   
    var isFromMyPage = Bool()
    
    var homeInfoObj = HomeInfo()

    var chatArray = [HomeInfo]()

    var refreshControl: UIRefreshControl!

    //MARK: - UIViewControllerLifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialMethod()
        
        (isFromMyPage) ? setMyPageData() : setPostData()
        registerCells()
        addNotification()
        addTapGesture()
        pullToRefersh()

        callApiToGetCommentList(isPullToRefresh: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - HelperMethods
    
    func initialMethod() {
        
        commentView.layer.shadowColor = UIColor.lightGray.cgColor
        commentView.layer.shadowOpacity = 0.3
        commentView.layer.shadowOffset = CGSize.zero
        commentView.layer.shadowRadius = 3
        
        self.messageSendTextView.textContainerInset = UIEdgeInsets(top: 6, left: 4, bottom: 10, right: 0)
        self.chatView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.commentTableView.tableHeaderView = headerView
        self.commentTableView.estimatedRowHeight = 400.0
      
        self.commentTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.commentTableView.allowsSelection = false
        self.messageSendTextView.setContentOffset(CGPoint.init(x: 5, y: 5), animated: false)
        self.messageSendTextView.delegate = self
        
        // Set Send Button Disable
        self.sendButton.isEnabled = false
        self.sendButton.alpha = 0.5
        
    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        commentTableView.addSubview(refreshControl)
        
    }
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiToGetCommentList(isPullToRefresh: true)
        
        refreshControl.endRefreshing()
    }
    
    func setMyPageData() {
    
        self.profileName.text = homeInfoObj.userNameString
        self.statusStringLabel.text = homeInfoObj.friendStatusString
        
        self.profileImageView.sd_setImage(with: homeInfoObj.userProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
        self.postImageView.sd_setImage(with: homeInfoObj.statusImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)
                    
        self.numberOfCommentsLabel.text  = (homeInfoObj.numberOfComment > 1) ? "\(homeInfoObj.numberOfComment)" + " comments" : "\(homeInfoObj.numberOfComment)" + " comment"
        self.postTimeLabel.text = homeInfoObj.activeTimeString
        
    }
    
    func setPostData() {
        
        self.profileName.text = homeInfoObj.friendNameString
        self.statusStringLabel.text = homeInfoObj.friendStatusString
        
        self.profileImageView.sd_setImage(with: homeInfoObj.friendProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
            
        self.postImageView.sd_setImage(with: homeInfoObj.statusImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)
        
        self.numberOfCommentsLabel.text  = (homeInfoObj.numberOfComment > 1) ? "\(homeInfoObj.numberOfComment)" + " comments" : "\(homeInfoObj.numberOfComment)" + " comment"
        self.postTimeLabel.text = homeInfoObj.activeTimeString
    }
    
    func registerCells() {
    
        self.commentTableView.register(UINib(nibName: "SenderChatTableViewCell", bundle: nil),forCellReuseIdentifier : "SenderChatTableViewCell")
        
        self.commentTableView.register(UINib(nibName: "RecieverChatTableViewCell", bundle: nil),forCellReuseIdentifier : "RecieverChatTableViewCell")
    }
    
    func addNotification() {
        
        // Add Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func addTapGesture() {
        
        //UITapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.commentTableView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: -  Observer Methods
    
    func keyboardWillAppear(_ notification : Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(), animations: {
                self.viewBottomConstraint.constant = keyboardSize.height
            }) { _ in
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
            }
            if self.chatArray.count > 1 {
                let indexPath = IndexPath(row: self.chatArray.count-1, section: 0)
                self.commentTableView.scrollToRow(at: indexPath,
                                                  at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification : Notification) {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.viewBottomConstraint.constant = 0
        }
    }
    
    //MARK: -  Dealloc method
    
    deinit {
        
        NotificationCenter.default.removeObserver(self.keyboardWillAppear, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self.keyboardWillHide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    //MARK: - UITableViewDataSourceMethods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count;
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath)as! SenderChatTableViewCell
        
        let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverChatTableViewCell", for: indexPath)as! RecieverChatTableViewCell
        
        let homeObj = chatArray[indexPath.row]
        
        if homeObj.userIdString == defaults.value(forKey: pUserId) as? String {
            
            senderCell.senderChatLabel.text = homeObj.commentString
            senderCell.senderNameLabel.text = homeObj.userNameString
          
            senderCell.senderImageView.sd_setImage(with: homeObj.userProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
            
            return senderCell

        } else {
            recieverCell.recieverChatLabel.text = homeObj.commentString
            recieverCell.recieverNameLabel.text = homeObj.userNameString

            recieverCell.recieverImageView.sd_setImage(with: homeObj.userProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
                
            return recieverCell

        }
    }
    
    //MARK: -  UIScroll Delegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view .endEditing(true)
    }
    
    //MARK: -  UITextView Delegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var str:NSString = textView.text! as NSString
        str = str.replacingCharacters(in: range, with: text) as NSString
        
        if (str.length != 0) {
            self.sendButton.isEnabled = true
            self.sendButton.alpha = 1.0
            self.textViewPlaceholderlabel.isHidden = true
        } else{
            self.sendButton.isEnabled = false
            self.sendButton.alpha = 0.5
            self.textViewPlaceholderlabel.isHidden = false
        }
        
        let fixedWidth = kWindowWidth - 155
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height > 100 {
            self.messageSendTextView.isScrollEnabled = true
            self.viewHeightConstraint.constant = 100 + 30
        } else {
            self.messageSendTextView.isScrollEnabled = false
            self.viewHeightConstraint.constant = newSize.height+17
        }
        
        if chatArray.count != 0 {
            //
            self.commentTableView.reloadData()
            ///
            let indexPath = IndexPath(row: chatArray.count-1, section: 0)
            self.commentTableView.scrollToRow(at: indexPath,
                                              at: UITableViewScrollPosition.bottom, animated: true)        }
        
        return true
    }
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    //MARK : - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: - UIButton Selector Methods
    
    @IBAction func showPhotoSelectorMethod(_ sender: UIButton) {
    
        EXPhotoViewer.showImage(from: postImageView)
        
    }
    
    //MARK: - UIButton Action

    @IBAction func sendButtonAction(_ sender: UIButton) {
     
        self.viewHeightConstraint.constant = 50
        
        if self.messageSendTextView.text.trimWhiteSpace().length != 0 {
            
            if self.messageSendTextView.text.trimWhiteSpace().length >= 1024 {
                let alert  = UIAlertController(title: "", message: "The character limit is 1024. Try a shorter message then send it again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            } else {
                
                self.sendButton.isEnabled = false
                self.sendButton.alpha = 0.5
                
                callApiToComment()
            }
        } else {
            
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Web Api Method
    
    func callApiToGetCommentList(isPullToRefresh : Bool) {
        
        self.view.endEditing(true)

        let paramDict = [KPost_Id : homeInfoObj.postIdString]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KViewComment, hudType: (isPullToRefresh) ? .smoothProgress : .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.chatArray = HomeInfo.getCommentListArray(responceDict: response)
                        self.chatArray = self.chatArray.reversed()
                        self.commentTableView.reloadData()
                        
                    } else if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 400 {

                        // no comment available
                        
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
   
    func callApiToComment() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = ["user_comment" : userId,
                         "post" : self.homeInfoObj.postIdString,
                         "comment" : self.messageSendTextView.text.trimWhiteSpace()
                         ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KComment, hudType: .noProgress) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.textViewPlaceholderlabel.isHidden = false
                        self.viewHeightConstraint.constant = 50
                        
                        //call get comment list api
                        let homeTempObj = HomeInfo()
                        homeTempObj.userIdString = defaults.value(forKey: pUserId) as! String
                        if defaults.value(forKey: Kname) as? String != nil{
                            homeTempObj.userNameString = defaults.value(forKey: Kname) as! String
                        }
                        else{
                            homeTempObj.userNameString = "No Name"
                        }
                        homeTempObj.commentString = self.messageSendTextView.text.trimWhiteSpace()
                        self.chatArray.append(homeTempObj)
                        
                        self.homeInfoObj.numberOfComment = self.homeInfoObj.numberOfComment + 1
                        self.numberOfCommentsLabel.text  = "\(self.homeInfoObj.numberOfComment)" + " comments"
                        self.commentDelegate?.toRefreshMyPost()
                        
                        self.messageSendTextView.text = ""
                        
                        
                        if (self.chatArray.count != 0) {
                            
                            self.commentTableView.reloadData()
                            let indexPath = IndexPath(row: self.chatArray.count-1, section: 0)
                            self.commentTableView.scrollToRow(at: indexPath,
                                                              at: UITableViewScrollPosition.bottom, animated: true)
                            
                        }
                        //    self.callApiToGetCommentList(isPullToRefresh: false)
                        
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
