
//
//  UploadPhotoViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class UploadPhotoViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var uploadPhotoImageView: UIImageView!
    
    @IBOutlet weak var saySomethingTextView: FLTextView!
   
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var tagProfileButton: UIButton!
  
    let categoryType = DropDown()

    var headerFrame = CGRect()

    var profileArray = [AUserInfo]()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryType
            
        ]
    }()
    
    var uploadInfo = HomeInfo()

    var categoryArray = [String]()
    var selectedCategoryArray = [AUserInfo]()
   // var selectedIdArray = [Int]()
    var selectedIdArray = NSMutableArray()


    //MARK: - UIViewControllerLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialMethod()
        
        setDropDown()
        
        setTapGestureMethod()
    }
    
    //MARK: - Helper Methods
    
    func initialMethod() {
        
        headerFrame = (self.tableView.tableHeaderView?.frame)!

        self.saySomethingTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.uploadPhotoImageView.image = self.uploadInfo.postImage
        
        self.tableView.register(UINib(nibName: "tagProfileTableViewCell", bundle: nil),forCellReuseIdentifier : "tagProfileTableViewCellId")
        
    }
    
    func setDropDown() {
        
        //drop down

        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        self.tagProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        
        setupCategoryDropDown( )

    }
    
    func setTapGestureMethod() {
        
        //UITapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func setupCategoryDropDown() {
        
        categoryType.anchorView = tagProfileButton
        
        self.categoryType.bottomOffset = CGPoint(x: 0, y: tagProfileButton.bounds.height)
        
        // Action triggered on selection
        categoryType.selectionAction = { [unowned self] (index, item) in
          
            var isFound : Bool = false
            
            for obj in self.selectedCategoryArray {
                
                if obj.categoryId ==  self.profileArray[index].categoryId {
                    isFound = true
                    return
                }
            }
            
            if !isFound {
                // Add selected tag in collection view
                self.selectedCategoryArray.append(self.profileArray[index])
                self.tableView.reloadData()
            }
 
        }
        
    }

    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    //MARK:- UIButton Action Methods
    
    @IBAction func tagButtonAction(_ sender: UIButton) {
        
        callApiMethodForViewProfile()
    }
    
    @IBAction func backBuutonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.callApiMethodForUploadPhoto()
    }
    
    //MARK: - UIButton Selector Methods
    
    @IBAction func deleteCategorySelectorMethod(_ sender: NotificationButton) {
        
        self.selectedCategoryArray.remove(at: sender.buttonIndexPath.item)
        self.tableView.reloadData()
    }
    
    //MARK: - UITextView delegate methods
    
    func textViewDidChange(_ textView: UITextView) {

        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        
        // Set header height acc. textview text
        
        self.tableView.beginUpdates()
        
        var headerNewFrame = headerFrame
        headerNewFrame.size.height = (headerNewFrame.size.height) + textView.frame.size.height - 33
        headerNewFrame.size.width = kWindowWidth
        self.tableView.tableHeaderView?.frame = headerNewFrame

        self.tableView.endUpdates()
    }

    //MARK:- UITable view data source and delegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "tagProfileTableViewCellId", for: indexPath)as! tagProfileTableViewCell
        
        cell.collectionView.register(UINib(nibName: "tagProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagProfileCollectionViewCellId")
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        
        return cell
    }
    
    func celheight() -> Int {
        
        var buttonwidth = 0
       
        for obj in self.selectedCategoryArray {
            
            let data = obj.categoryProfileTypeString
            let buttonWidth = data.width(withConstraintedHeight: 30, font: .systemFont(ofSize: 14))
            
            buttonwidth += Int(buttonWidth)
            buttonwidth += 65
        }
        
        let count = buttonwidth/Int(kWindowWidth)
        return count+1
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(celheight() * 60)
    }
    
    //MARK: -  UICollectionView Datasource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let obj = self.selectedCategoryArray[indexPath.item]
        let data = obj.categoryProfileTypeString
       
        let buttonWidth = data.width(withConstraintedHeight: 30, font: .systemFont(ofSize: 15))
  
        return CGSize(width: buttonWidth + 65, height:50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedCategoryArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagProfileCollectionViewCellId", for: indexPath) as! tagProfileCollectionViewCell
        
        let obj = self.selectedCategoryArray[indexPath.item]
        collectionCell.categoryLabel.text = obj.categoryProfileTypeString
        collectionCell.categoryButton.buttonIndexPath = indexPath
        
        collectionCell.categoryButton.addTarget(self, action: #selector(deleteCategorySelectorMethod(_:)), for: .touchUpInside)

        return collectionCell
    }
    
    //MARK: - WebService Method
    
    func callApiMethodForViewProfile() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId
            ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KGetProfiletype, hudType: .simple) { (result, error, httpCode) in
            
            let response = result as! Dictionary<String, AnyObject>
            
            if error == nil {
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                    
                    let reponseArray = response.validatedValue("multiple_profile_type_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
                    
                    self.profileArray.removeAll()
                    self.categoryArray.removeAll()
                    
                    self.profileArray = AUserInfo.getProfileCategory(responceArray: reponseArray)
                    
                    for profileItem in self.profileArray {
                        self.categoryArray.append(profileItem.categoryProfileTypeString)
                    }
                    
                    self.categoryType.dataSource = self.categoryArray
                    
                    self.categoryType.show()

                } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
                
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }

    func callApiMethodForUploadPhoto() {
        
        for profileItem in self.selectedCategoryArray {
            let obj  = profileItem.categoryId as Int
            selectedIdArray.add(obj)

        }
        
        let postDateTime = Date()
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId,
            KStatus_on_post : self.saySomethingTextView.text,
            KUserPost : "",

            KPost_time : "\(postDateTime.convertDateToTimeStamp())",
            
            KTag : selectedIdArray
            ] as [String : Any]
        
        var mediaArray = [Dictionary<String, AnyObject>]()
        
        if let avatar = uploadInfo.postImage {
            let mediaInfoDict = [
                keyMultiPartData : avatar.toData(),
                keyMultiPartFileType : multiPartFileTypeImage,
                keyMultiPartKeyAtServerSide : KUserPost
                ] as [String : AnyObject]
            
            mediaArray.append(mediaInfoDict)
        }
        
        var hud = MBProgressHUD(for: kAppDelegate.window!)
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
        }
        
        hud?.show(animated: true)
        
        RServiceHelper.multiPart(paramDict, apiName: KuploadPhoto, media: mediaArray, showHud: false, isUsingFilePath: false) { (result, error) in
            
            DispatchQueue.main.async {
                hud?.hide(animated: true)
            }
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                                        
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        _ =     presentAlertWithOptions("", message: response["message"] as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                            
                            let pageVcObj = HomeMyPageViewController()
                            pageVcObj.isfromPostImage = true
                            self.navigationController?.pushViewController(pageVcObj, animated: true)
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
    
    //MARK:- Memory management method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  

}
