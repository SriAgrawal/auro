
//
//  ChatViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var textViewPlaceholderlabel: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageSendTextView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var navigationBarLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    var contactId : String = ""
    var recieverName : String = ""
    var recieverImageProfile : URL!

    var attactedImage : UIImage?
    
    var chatData = ChatInfo()
    
    var refreshControl: UIRefreshControl!

    var isFromPush : Bool = false
    
    //MARK: - UIViewControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
        UserDefaults.standard.set(contactId, forKey: pChatId)
        
        registerCell()
        
        callApiToGetChatHistory(isPullToRefresh: false)
        pullToRefersh()
        
        addNotification()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)

        UserDefaults.standard.removeObject(forKey: pChatId)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helper Method
    
    func addNotification() {
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.rehreshChatMethod), name: Notification.Name("onChatScreen"), object: nil)
        
    }
    
    func rehreshChatMethod(userInfo : Notification) {
    
        callApiToGetChatHistory(isPullToRefresh: true)

    }
    
    func initialMethod() {
 
        if !isFromPush {
            self.navigationBarLabel.text = recieverName
            self.profileImage.sd_setImage(with: recieverImageProfile, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        }
     
        self.messageSendTextView.textContainerInset = UIEdgeInsets(top: 6, left: 4, bottom: 10, right: 0)
        
        self.chatView.layer.borderColor = UIColor.lightGray.cgColor
      
        self.chatTableView.estimatedRowHeight = 143.0
        
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.chatTableView.allowsSelection = false
        self.messageSendTextView.setContentOffset(CGPoint.init(x: 5, y: 5), animated: false)
        
        self.messageSendTextView.delegate = self
        
        // Set Send Button Disable
        self.sendButton.isEnabled = false
        self.sendButton.alpha = 0.5
       
        // Add Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //UITapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.chatTableView.addGestureRecognizer(tapGesture)
    }
    
    
    func setRecieverData() {
        
        self.navigationBarLabel.text = chatData.recieverName
        self.profileImage.sd_setImage(with: chatData.recieverImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
    }
    
    func registerCell() {
    
        self.chatTableView.register(UINib(nibName: "SenderChatTableViewCell", bundle: nil),forCellReuseIdentifier : "SenderChatTableViewCell")
        
        self.chatTableView.register(UINib(nibName: "RecieverChatTableViewCell", bundle: nil),forCellReuseIdentifier : "RecieverChatTableViewCell")
        
        self.chatTableView.register(UINib(nibName: "SenderChatImageTableViewCell", bundle: nil),forCellReuseIdentifier : "SenderChatImageTableViewCell")
        
        self.chatTableView.register(UINib(nibName: "RecieverChatImageTableViewCell", bundle: nil),forCellReuseIdentifier : "RecieverChatImageTableViewCell")
 
    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        chatTableView.addSubview(refreshControl)
        
    }
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiToGetChatHistory(isPullToRefresh: true)
        
        refreshControl.endRefreshing()
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
            if self.chatData.chatArray.count > 1 {
                let indexPath = IndexPath(row: self.chatData.chatArray.count-1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath,
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
        return chatData.chatArray.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath)as! SenderChatTableViewCell
        
        let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverChatTableViewCell", for: indexPath)as! RecieverChatTableViewCell
       
        let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "SenderChatImageTableViewCell", for: indexPath)as! SenderChatImageTableViewCell
        
        let recieverImageCell = tableView.dequeueReusableCell(withIdentifier: "RecieverChatImageTableViewCell", for: indexPath)as! RecieverChatImageTableViewCell
        
        senderCell.senderNameLabel.isHidden = true
        recieverCell.recieverNameLabel.isHidden = true
        
        let chatObj = chatData.chatArray[indexPath.row]
        
        if chatObj.senderId == defaults.value(forKey: pUserId) as? String {
            
            if chatObj.messageType == "image" {
                
                senderImageCell.senderShowPhotoButton.tag = indexPath.row

                senderImageCell.senderProfileImageView.sd_setImage(with: chatData.senderImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
                senderImageCell.senderSendedImageView.sd_setImage(with: chatObj.attachedImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)
                
                senderImageCell.senderShowPhotoButton.addTarget(self, action: #selector(senderShowPhotoSelectorMethod(_:)), for: .touchUpInside)

                return senderImageCell
            
            } else {

                senderCell.senderChatLabel.text = chatObj.messageString
                senderCell.senderImageView.sd_setImage(with: chatData.senderImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
                
                return senderCell
                
            }
            
        } else {
            
            if chatObj.messageType == "image" {
               
                recieverImageCell.recieverShowPhotoButton.tag = indexPath.row

                recieverImageCell.recieverProfileImageView.sd_setImage(with: chatData.recieverImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
                recieverImageCell.recieverSendedImageView.sd_setImage(with: chatObj.attachedImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)
                
                recieverImageCell.recieverShowPhotoButton.addTarget(self, action: #selector(recieverShowPhotoSelectorMethod(_:)), for: .touchUpInside)

                return recieverImageCell
                
            } else {
                
                recieverCell.recieverChatLabel.text = chatObj.messageString
                recieverCell.recieverImageView.sd_setImage(with: chatData.recieverImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
                
                return recieverCell
            }
            
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
       
        } else {
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
        
        if chatData.chatArray.count != 0 {
            //
            self.chatTableView.reloadData()
            //
            let indexPath = IndexPath(row: chatData.chatArray.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath,
                                           at: UITableViewScrollPosition.bottom, animated: true)
        }
        
        return true
    }
    
    
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    //MARK : - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func senderShowPhotoSelectorMethod(_ sender: UIButton) {
        
        let path = IndexPath(row:sender.tag, section: 0)
        let cell =  self.chatTableView.cellForRow(at: path) as! SenderChatImageTableViewCell
        
        EXPhotoViewer.showImage(from: cell.senderSendedImageView)
        
    }
    
    @IBAction func recieverShowPhotoSelectorMethod(_ sender: UIButton) {
        
        let path = IndexPath(row:sender.tag, section: 0)
        let cell =  self.chatTableView.cellForRow(at: path) as! RecieverChatImageTableViewCell
        
        EXPhotoViewer.showImage(from: cell.recieverSendedImageView)
        
    }
    
    //MARK: - UIButton Action Method
    
    @IBAction func chatAttachmentButtonAction(_ sender: UIButton) {
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chatSendButtonAction(_ sender: UIButton) {
        
        self.viewHeightConstraint.constant = 50
        
        if self.messageSendTextView.text.trimWhiteSpace().length != 0 {
            
            if self.messageSendTextView.text.trimWhiteSpace().length >= 1024 {
                
                let alert  = UIAlertController(title: "", message: "The character limit is 1024. Try a shorter message then send it again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                callApiToSendChatMessage(msgType: "text")
            }
        }
    }
    
    @IBAction func backButonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if isFromPush {
            self.dismiss(animated:false, completion : nil)

        } else {
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    //MARK: - Camera Method
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
    
    //MARK: - Galery Method
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            self.attactedImage = pickedImage
            callApiToSendChatMessage(msgType: "image")

        }

        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    

    
    //MARK:- Web Api Methods
    
    func callApiToGetChatHistory(isPullToRefresh:Bool) {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = ["message_sender" : userId,
                          "message_receiver" : contactId
        ]

        ServiceHelper.request(params: paramDict, method: .post, apiName: KChatHistory, hudType: (isPullToRefresh) ? .smoothProgress : .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.chatData = ChatInfo.getChistoryArray(responceDict: response)
                       
                        // chat is presented from push
                        if self.isFromPush {
                            self.setRecieverData()
                        }
                        
                        self.chatTableView.reloadData()
                        
                        if self.chatData.chatArray.count != 0 {
                            
                            let indexPath = IndexPath(row: self.chatData.chatArray.count-1, section: 0)
                            self.chatTableView.scrollToRow(at: indexPath,
                                                           at: UITableViewScrollPosition.bottom, animated: true)
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

    func callApiToSendChatMessage(msgType: String) {
        
        let chatDateTime = Date()

        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = ["message_sender" : userId,
                         "message_receiver" : contactId,
                         "messages" : self.messageSendTextView.text.trimWhiteSpace(),
                         "type_of_messages" : msgType,
                         "attached_image" : "",
                         "chat_time" : "\(chatDateTime.convertDateToTimeStamp())"
                         ]
        
        var mediaArray = [Dictionary<String, AnyObject>]()
        
        if let avatar = self.attactedImage {
            let mediaInfoDict = [
                keyMultiPartData : avatar.toData(),
                keyMultiPartFileType : multiPartFileTypeImage,
                keyMultiPartKeyAtServerSide : KAttachedImage
                ] as [String : AnyObject]
            
            mediaArray.append(mediaInfoDict)
        }
        
        var hud = MBProgressHUD(for: kAppDelegate.window!)
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
        }
        
        hud?.show(animated: true)
        
        RServiceHelper.multiPart(paramDict, apiName: KUserChat, media: mediaArray, showHud: false, isUsingFilePath: false) { (result, error) in
            
            DispatchQueue.main.async {
                hud?.hide(animated: true)
            }
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.sendButton.isEnabled = false
                        self.sendButton.alpha = 0.5
                        self.textViewPlaceholderlabel.isHidden = false
                        self.messageSendTextView.text = ""
                        
                        self.callApiToGetChatHistory(isPullToRefresh: true)
                        
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
