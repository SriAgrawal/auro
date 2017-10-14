//
//  TabBarViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/12/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
        addNotification()
    }
    
    //MARK: - Helper Method
    
    func addNotification() {
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.pushToNotificationScreenMethod), name: Notification.Name("pushNotificationScreen"), object: nil)
        
    }
    
    func initialMethod() {
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.homeButton.isSelected = true
        self.homeButton.setImage(UIImage(named:"home_sel.png"), for: .normal)
        self.homeLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)

        let vcObj = HomeViewController(nibName: "HomeViewController", bundle: nil)
        addViewController(vcObj)
        
    }
    
    func selectSelectedButton(_ sender: UIButton) {
        
        self.homeButton.isSelected = false
        self.contactButton.isSelected = false
        self.chatButton.isSelected = false
        self.notificationsButton.isSelected = false
        self.settingsButton.isSelected = false
        sender.isSelected = true
    }
    
    func addViewController(_ childController: UIViewController) {
        childController.view.frame = self.containerView.bounds;
        self.addChildViewController(childController)
        self.containerView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    func removeViewController(_ childController: UIViewController) {
        childController.willMove(toParentViewController: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
    }
    
    func pushToNotificationScreenMethod() {
        
        self.homeButton.isSelected = false
        self.contactButton.isSelected = false
        self.chatButton.isSelected = false
        self.notificationsButton.isSelected = true
        self.chatButton.isSelected = false
        
        self.notificationLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.homeLabel.textColor = UIColor.darkGray
        self.settingLabel.textColor = UIColor.darkGray
        self.chatLabel.textColor = UIColor.darkGray
        self.contactLabel.textColor = UIColor.darkGray
        
        removeViewController(self.childViewControllers.first!)
        let vcObj = NotificationsViewController(nibName:"NotificationsViewController", bundle: nil)
        addViewController(vcObj)
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func homeBtnAction(_ sender: UIButton) {
        
        self.selectSelectedButton(sender)
        self.homeLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.notificationLabel.textColor = UIColor.darkGray
        self.settingLabel.textColor = UIColor.darkGray
        self.chatLabel.textColor = UIColor.darkGray
        self.contactLabel.textColor = UIColor.darkGray
        
        removeViewController(self.childViewControllers.first!)

        let vcObj = HomeViewController(nibName:"HomeViewController", bundle: nil)
        addViewController(vcObj)
        
    }
    
    @IBAction func chatBtnAction(_ sender: UIButton) {
        self.selectSelectedButton(sender)
        self.homeButton.setImage(UIImage(named:"home.png"), for: .normal)

        self.chatLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.notificationLabel.textColor = UIColor.darkGray
        self.settingLabel.textColor = UIColor.darkGray
        self.homeLabel.textColor = UIColor.darkGray
        self.contactLabel.textColor = UIColor.darkGray
        
        removeViewController(self.childViewControllers.first!)

        let vcObj = ChatListViewController(nibName:"ChatListViewController", bundle: nil)
        addViewController(vcObj)
        
    }
    
    @IBAction func contactBtnAction(_ sender: UIButton) {
        self.selectSelectedButton(sender)
        self.homeButton.setImage(UIImage(named:"home.png"), for: .normal)

        self.contactLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.chatLabel.textColor = UIColor.darkGray
        self.settingLabel.textColor = UIColor.darkGray
        self.homeLabel.textColor = UIColor.darkGray
        self.notificationLabel.textColor = UIColor.darkGray
        
        removeViewController(self.childViewControllers.first!)
        let contactObj = ContactViewController(nibName:"ContactViewController", bundle: nil)
        contactObj.isBackButton = true
        addViewController(contactObj)
    }
    
    @IBAction func notificationBtnAction(_ sender: UIButton) {
        self.selectSelectedButton(sender)
        self.homeButton.setImage(UIImage(named:"home.png"), for: .normal)

        self.notificationLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.homeLabel.textColor = UIColor.darkGray
        self.contactLabel.textColor = UIColor.darkGray
        self.settingLabel.textColor = UIColor.darkGray
        self.chatLabel.textColor = UIColor.darkGray
        
        removeViewController(self.childViewControllers.first!)

        let vcObj = NotificationsViewController(nibName:"NotificationsViewController", bundle: nil)
        addViewController(vcObj)
        
    }
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        self.selectSelectedButton(sender)
        self.homeButton.setImage(UIImage(named:"home.png"), for: .normal)

        self.settingLabel.textColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.contactLabel.textColor = UIColor.darkGray
        self.chatLabel.textColor = UIColor.darkGray
        self.notificationLabel.textColor = UIColor.darkGray
        self.homeLabel.textColor = UIColor.darkGray
        
        removeViewController(self.childViewControllers.first!)

        let vcObj = SettingsViewController(nibName:"SettingsViewController", bundle: nil)
        addViewController(vcObj)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
