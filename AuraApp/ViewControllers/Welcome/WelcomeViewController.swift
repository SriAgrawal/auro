//
//  WelcomeViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 11/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLbel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var agreeImageView: UIImageView!
    
    //MARK: - UIViewControllerLifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
    }

    //MARK: - Helper Methods
   
    func initialMethod() {
        
        let str = "Welcome to  \"AURA\"  app"
        var welcomeString = NSMutableAttributedString()
        welcomeString = NSMutableAttributedString(string: str, attributes: [NSFontAttributeName:UIFont(name: "CenturyGothic-Bold", size: 19.0),])
        welcomeString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.0/255.0, green: 186.0/255.0, blue: 184.0/255.0, alpha: 1.0), range: NSRange(location:11,length:7))
        
        self.welcomeLbel.attributedText = welcomeString
    }
    
    //MARK: - UIButton Actions methods
    
    @IBAction func termsServiceButtonAction(_ sender: UIButton) {
        
        let termVc = TermsServicesViewController()
        termVc.isController = true
        
        self.navigationController?.pushViewController(termVc, animated: true)
    }
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.isSelected = !sender.isSelected
        if self.checkButton.isSelected {
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        let termsVc = TermsServicesViewController()
        termsVc.isController = false
        self.navigationController?.pushViewController(termsVc, animated: true)
    }
    
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        presentAlert("", msgStr: "Please accept Terms and Conditions.", controller: self)
        
    }
    
    //MARK:- Menory managemnet method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
