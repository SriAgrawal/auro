//
//  BackupViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/14/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import QuartzCore

class BackupViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    var backUpObj = AUserInfo()
    var backUpArray = [String]()
    var backUpNameArray = [String]()
    
    @IBOutlet weak var backUpMailBtn: UIButton!
    @IBOutlet weak var backUptitleView: UIView!
    @IBOutlet weak var backUpView: UIView!
    @IBOutlet weak var backUpImageView: UIImageView!
    @IBOutlet weak var backUpTableView: UITableView!
    @IBOutlet weak var sizeNameLabel: UILabel!
    @IBOutlet weak var googleDriveNameLabel: UILabel!
    @IBOutlet weak var localNameLabel: UILabel!
    @IBOutlet var backUpFooterView: UIView!
    @IBOutlet var backUpHeaderView: UIView!
    override func viewDidLoad() {
        
        //MARK: - UIViewController LifeCycle Method
        super.viewDidLoad()
        self.initialMethod()
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    //MARK: _ Helper Methods.
    func initialMethod()  {
        self.navigationController?.setNavigationBarHidden(true, animated: false )
        self.backUpTableView.tableHeaderView = backUpHeaderView
        self.backUpTableView.tableFooterView = backUpFooterView
        self.localNameLabel.text = backUpObj.local
        self.googleDriveNameLabel.text = backUpObj.googleDrive
        self.sizeNameLabel.text = backUpObj.size
        self.backUpMailBtn.setTitle(backUpObj.account,for: .normal)
        self.backUpView.backgroundColor = .white
        self.backUpTableView.register(UINib(nibName:"BackUpTableViewCell", bundle: nil), forCellReuseIdentifier: "BackUpTableViewCell")
        self.dropShadow()
        
        
        
    }
    
    func dropShadow() {
        
        backUpView.layer.masksToBounds = false
        backUpView.layer.shadowColor = UIColor.gray.cgColor
        backUpView.layer.shadowOpacity = 0.2
        backUpView.layer.shadowOffset = CGSize(width: -1, height: 1)
        backUpView.layer.shadowRadius = 10
        
        backUpView.layer.shadowPath = UIBezierPath(rect: CGRect(x:0, y:0, width:UIScreen.main.bounds.width + 50, height:64)).cgPath
        //        backUpView.layer.shouldRasterize = true
        
        backUpView.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"BackUpTableViewCell") as? BackUpTableViewCell
        
        backUpTableView.allowsSelection = true
        cell?.selectionStyle = .none
        switch indexPath.row {
        case 0:
            let stringValue = "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
            let attrString = NSMutableAttributedString(string: stringValue)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 12 // change line spacing between paragraph like 36 or 48
            style.minimumLineHeight = 12 // change line spacing between each line like 30 or 40
            attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: stringValue.characters.count))
            cell?.dataLabel.attributedText = attrString
            cell?.backUpButton.addTarget(self, action: #selector(buttonTap), for: UIControlEvents.touchUpInside)
            
            
            break
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 155
        
    }
    
    //MARK: - UIButton Actions.
    @IBAction func backUpMailBtnAction(_ sender: UIButton) {
        let vcObj = BackUpPopUpViewController()
        vcObj.modalPresentationStyle = .overCurrentContext
        self.present(vcObj, animated: false, completion: nil)
    }
    
    @IBAction func buttonTap(sender: AnyObject) {
        self.view .endEditing(true)
        presentAlert("", msgStr: "Work in progress...", controller: self)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
