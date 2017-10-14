//
//  HomeMyPageViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 17/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class HomeMyPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,refreshpostDelegate {
    
    @IBOutlet weak var homeMyPageTableView: UITableView!
    
    var homePageInfoArray = [HomeInfo]()
    
    var isfromPostImage : Bool = false
    
    var refreshControl: UIRefreshControl!

    //MARK: -  UIViewControllerLifeCycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMethod()
        pullToRefersh()

    }

    //MARK: - Helper Metods
    
    func initialMethod() {
       
        self.homeMyPageTableView.estimatedRowHeight = 400
        self.homeMyPageTableView.register(UINib(nibName: "HomeTableViewCell",bundle: nil),forCellReuseIdentifier : "HomeTableViewCell")
        self.homeMyPageTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.callApiMethodForMyPage(isPullToRefresh:false)
    }
    
    func pullToRefersh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        homeMyPageTableView.addSubview(refreshControl)
        
    }
    
    
    func refresh(_ sender: Any) {
        // refresh tableView
        callApiMethodForMyPage(isPullToRefresh: true)
        
        refreshControl.endRefreshing()
    }
    
    //MARK : - UITableViewDataSource Methods
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homePageInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)as! HomeTableViewCell
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
        cell.commentButton.tag = indexPath.row+100
        cell.showPhotoButton.tag = indexPath.row
        
        cell.commentButton.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        cell.showPhotoButton.addTarget(self, action: #selector(showPhotoSelectorMethod(_:)), for: .touchUpInside)

        let homePageInfo = homePageInfoArray[indexPath.row]
        cell.friendsNameLabel.text = homePageInfo.userNameString
        cell.friendsStatus.text = homePageInfo.userStatusString
        cell.commentLabel.text  = (homePageInfo.numberOfComment > 1) ? "\(homePageInfo.numberOfComment)" + " comments" : "\(homePageInfo.numberOfComment)" + " comment"
        cell.activeTimeLabel.text = homePageInfo.activeTimeString
        
        cell.profileImageView.sd_setImage(with: homePageInfo.userProfileImage, placeholderImage: UIImage(named:"profile_img"), options: .refreshCached)
        
        cell.postPhotoImageView.sd_setImage(with: homePageInfo.statusImage, placeholderImage: UIImage(named:"imagePlaceholder"), options: .refreshCached)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentVc = CommentViewController()
        commentVc.homeInfoObj = homePageInfoArray[indexPath.row]
        commentVc.isFromMyPage = true
        commentVc.commentDelegate = self
        self.navigationController?.pushViewController(commentVc, animated: true)

    }
    
    //CustomDelegateMethod
    func toRefreshMyPost(){
        self.callApiMethodForMyPage(isPullToRefresh:false)

    }
    
    //MARK : UIButton Actions Methods
    
    @IBAction func showPhotoSelectorMethod(_ sender: UIButton) {
        
        let path = IndexPath(row:sender.tag, section: 0)
        let cell =  self.homeMyPageTableView.cellForRow(at: path) as! HomeTableViewCell
        
        EXPhotoViewer.showImage(from: cell.postPhotoImageView)
        
    }
    
    @IBAction func commentButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {

        if isfromPostImage {
            
            // pop to Home view controller
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            
        } else {
            self.navigationController?.popViewController(animated: true)

        }
    }
    
   //MARK: - WebServiceMethods for MyPage
    
    func callApiMethodForMyPage(isPullToRefresh:Bool) {
    
    guard let userId = defaults.value(forKey: pUserId) as? String else {
        return
    }
    
    let paramDict = [
        KUser_Id : userId
    ]
    
        ServiceHelper.request(params: paramDict, method: .post, apiName: KmyPage, hudType: (isPullToRefresh) ? .smoothProgress :.simple) { (result, error, httpCode) in
        
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                  
                        let reponseArray = response.validatedValue("mypage_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
                    
                        self.homePageInfoArray = HomeInfo.getDataOfMypage(postInfo: reponseArray)
                        self.homeMyPageTableView.reloadData()
                
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
    
    //MARK:- Memory management method
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
