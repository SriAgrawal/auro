//
//  BackUpPopUpViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/16/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class BackUpPopUpViewController: UIViewController {
    var backUpObj = AUserInfo()
    @IBOutlet weak var backupAddPopUpBtn: UIButton!
    @IBOutlet weak var backupPopUpBtn: UIButton!
    @IBOutlet weak var backUpPopUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    @IBOutlet weak var emailLabel: UILabel!
    func initialMethod() {
        self.emailLabel.text = backUpObj.account
        if UIScreen.main.bounds.width == 320 {
            //            self.topConstraint.constant = 1
            //            self.topConstraintBtn.constant = 1
        }
    }
    //MARK: - UIButton Action
    @IBAction func okBtnCkick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func backupPopUpBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.backupPopUpBtn.isSelected = true
        self.backupAddPopUpBtn.isSelected = false
    }
    @IBAction func backupPopUpAddClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.backupPopUpBtn.isSelected = false
        self.backupAddPopUpBtn.isSelected = true
        
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
