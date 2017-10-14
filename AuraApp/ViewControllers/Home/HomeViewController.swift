//
//  HomeViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 16/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,refreshpostDelegate {
    
    @IBOutlet weak var addPhotosUnderlineLabel: UILabel!
    @IBOutlet weak var cameraUnderLineLabel: UILabel!

    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
 
    @IBOutlet weak var homeTableView: UITableView!
   
    @IBOutlet weak var userStatusLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
   
    @IBOutlet weak var userProfileImage: UIImageView!
   
    var imagePicker = UIImagePickerController()
    var profileImage : String = ""
    var homePageInfoArray = [HomeInfo]()
   
    var homeInfo = HomeInfo()
    
    var homeInfoObj = HomeInfo()

    var refreshControl: UIRefreshControl!
    
    //MARK: - UIViewControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        pullToRefersh()
        
    }

    //MARK : - Helper Methods
    
    func initialMethod() {
        
        imagePicker.delegate = self
        
        self.addPhotosUnderlineLabel.isHidden = true
        self.cameraUnderLineLabel.isHidden = true
        self.homeTableView.estimatedRowHeight = 400
        self.homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil),forCellReuseIdentifier : "HomeTableViewCell")
        self.homeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        callApiMethodToHome(isPullToRefresh: false)
    }
    
    func setData() {
    
        self.userNameLabel.text = homeInfoObj.userNameString
        self.userStatusLabel.text = homeInfoObj.userStatusString
      
        if  (homeInfoObj.userProfileImage != nil) {
            self.userProfileImage.sd_setImage(with: homeInfoObj.userProfileImage!, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        }

    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        homeTableView.addSubview(refreshControl)
        
    }
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiMethodToHome(isPullToRefresh: true)
        
        refreshControl.endRefreshing()
    }
    
    //MARK: - UITableView dataSource and delegate methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeInfoObj.friendPostArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)as! HomeTableViewCell
       
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
       
        cell.commentButton.tag = indexPath.row+100
        cell.showPhotoButton.tag = indexPath.row

        cell.commentButton.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        cell.showPhotoButton.addTarget(self, action: #selector(showPhotoSelectorMethod(_:)), for: .touchUpInside)

        let homeData = homeInfoObj.friendPostArray[indexPath.row]
       
        cell.friendsNameLabel.text = homeData.friendNameString
        cell.friendsStatus.text = homeData.friendStatusString
        cell.commentLabel.text  = (homeData.numberOfComment > 1) ? "\(homeData.numberOfComment)" + " comments" : "\(homeData.numberOfComment)" + " comment"
        cell.activeTimeLabel.text = homeData.activeTimeString
        
        cell.profileImageView.sd_setImage(with: homeData.friendProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
        cell.postPhotoImageView.sd_setImage(with: homeData.statusImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // navigate to comment screen
        let commentVc = CommentViewController()
        commentVc.homeInfoObj = homeInfoObj.friendPostArray[indexPath.row]
        commentVc.commentDelegate = self
        self.navigationController?.pushViewController(commentVc, animated: true)
        
    }
    
    //MARK:- UIImage Picker Delegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            self.homeInfo.postImage = pickedImage
            
            let uploadVc = UploadPhotoViewController()
            uploadVc.uploadInfo  =  homeInfo
            self.navigationController?.pushViewController(uploadVc, animated: true)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        
        } else {
//            let ac = UIAlertController(title: "", message: "Image has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
        }
    }
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //CustomDelegateMethod
    func toRefreshMyPost(){
        callApiMethodToHome(isPullToRefresh: false)
    }
    
    //MARK:- UIButton Actions methods
    
    @IBAction func showPhotoSelectorMethod(_ sender: UIButton) {
        
        let path = IndexPath(row:sender.tag, section: 0)
        let cell =  self.homeTableView.cellForRow(at: path) as! HomeTableViewCell
        
        EXPhotoViewer.showImage(from: cell.postPhotoImageView)

    }
    
    @IBAction func commentButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
       
        let searchVc = SearchViewController()
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    @IBAction func addPhotosAction(_ sender: UIButton) {
       
        self.cameraButton.isSelected = false
        self.addPhotosButton.isSelected = true
        
        if(addPhotosButton.isSelected == true) {
            self.addPhotosUnderlineLabel.isHidden = false
            self.cameraUnderLineLabel.isHidden = true
        }
        
        self.openGallary()
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
       
        self.cameraButton.isSelected = true
        self.addPhotosButton.isSelected = false
        
        if(cameraButton.isSelected == true) {
            cameraUnderLineLabel.isHidden = false
            addPhotosUnderlineLabel.isHidden = true
        }
    
        self.openCamera()
    }
    
    @IBAction func myPageAction(_ sender: UIButton) {
        
        let myPageVc = HomeMyPageViewController()
        self.navigationController?.pushViewController(myPageVc, animated: true)
        
    }
    
    //MARK: - CameraMethod
   
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
  
    // MARK: - Web Api Method
   
    func callApiMethodToHome(isPullToRefresh:Bool) {

        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: Khome, hudType: (isPullToRefresh) ? .smoothProgress : .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        self.homeInfoObj = HomeInfo.getHomePageListArray(responceDict: response)
                    
                        self.setData()
                        self.homeTableView.reloadData()
                    
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }

    // MARK: - Memory Management method

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
