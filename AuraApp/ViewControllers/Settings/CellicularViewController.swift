//
//  CellicularViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/14/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class CellicularViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleArray = [String]()
    
    @IBOutlet weak var cellicularView: UIView!
    @IBOutlet weak var cellicularTableView: UITableView!
   
    var chatInfoObj = ChatInfo()
    
    //MARK: - ViewLifeCycleMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        callApiToSGetDataUsage()
    }
    
    //MARK: - Helper Method
    
    func initialMethod() {
        
        self.navigationController?.isNavigationBarHidden = true
      
        self.cellicularTableView.register(UINib(nibName:"CellicularHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CellicularHeaderTableViewCell")
        self.cellicularTableView.register(UINib(nibName:"CellicularTableViewCell", bundle: nil), forCellReuseIdentifier: "CellicularTableViewCell")
      
        titleArray = ["Network Usage", "When connected to wi-fi" ,"When Roaming"]
    }
    
    //MARK:- UIButton Action Methods
    
    @IBAction func photoButtonSelector(_ sender: NotificationButton) {
        
        switch sender.buttonIndexPath.section {
        case 0:
            chatInfoObj.mobileDataBool = true
            break
          
        case 1:
            chatInfoObj.wifiBool = true

            break
            
        case 2:
            chatInfoObj.roamingBool = true

            break
            
        default:
            break
        }
        
        callApiToSetDataUsage()

    }
    
    @IBAction func mediaButtonSelector(_ sender: NotificationButton) {
        
        switch sender.buttonIndexPath.section {
        case 0:
            chatInfoObj.mobileDataBool = false
            break
            
        case 1:
            chatInfoObj.wifiBool = false
            
            break
            
        case 2:
            chatInfoObj.roamingBool = false
            
            break
            
        default:
            break
        }
        
        callApiToSetDataUsage()

    }
    
    //MARK: - UITableView DataSource Method
   
    func numberOfSections(in tableView: UITableView) -> Int{
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "CellicularHeaderTableViewCell") as? CellicularHeaderTableViewCell
        
        headerView?.cellicularName.text = titleArray[section]
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellicularTableViewCell") as? CellicularTableViewCell
        cell?.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell?.topConstraint.constant = 8
            cell?.TopBtnConstraint.constant = 8
            cell?.mobileDataLabel.isHidden = false
            cell?.autoDownloadLabel.isHidden = false
        } else {
            cell?.topConstraint.constant = -40
            cell?.TopBtnConstraint.constant = -40
            cell?.mobileDataLabel.isHidden = true
            cell?.autoDownloadLabel.isHidden = true
            
        }
        
        cell?.photosButton.buttonIndexPath = indexPath
        cell?.mediaFileButton.buttonIndexPath = indexPath

        cell?.photosButton.addTarget(self, action: #selector(photoButtonSelector(_:)), for: .touchUpInside)
        cell?.mediaFileButton.addTarget(self, action: #selector(mediaButtonSelector(_:)), for: .touchUpInside)

        switch indexPath.section {
        case 0:
            
            cell?.photosButton.isSelected = chatInfoObj.mobileDataBool
            cell?.mediaFileButton.isSelected = !chatInfoObj.mobileDataBool
            
            break
            
        case 1:
            cell?.photosButton.isSelected = chatInfoObj.wifiBool
            cell?.mediaFileButton.isSelected = !chatInfoObj.wifiBool
            
            break
            
        case 2:
            cell?.photosButton.isSelected = chatInfoObj.roamingBool
            cell?.mediaFileButton.isSelected = !chatInfoObj.roamingBool
            
            break
            
        default:
            break
        }
      
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 145
        } else {
            return 95
        }
    }
    
    //MARK: - UIButton Action Method
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Web Api Methods
    
    func callApiToSGetDataUsage() {
        
        self.view.endEditing(true)
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KViewDataUsage, hudType: .smoothProgress) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        let dataUsageArray = response.validatedValue("data_usage", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>

                        self.chatInfoObj = ChatInfo.getdataUsage(responceArray: dataUsageArray)
                        self.cellicularTableView.reloadData()
                        
                    }
                }
            } else {
                
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiToSetDataUsage() {
        
        self.view.endEditing(true)
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [KUser_Id : userId,
                         KMobileData : self.chatInfoObj.mobileDataBool,
                         KConnectedToWifi : self.chatInfoObj.wifiBool,
                         KWhenRoaming : self.chatInfoObj.roamingBool,
                         ] as [String : Any]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KDataUsage, hudType: .smoothProgress) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
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
