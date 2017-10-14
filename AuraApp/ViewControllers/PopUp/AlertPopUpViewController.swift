//
//  AlertPopUpViewController.swift
//  AuraApp
//
//  Created by Krati Agarwal on 29/09/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

typealias alertViewCompletionBlock = (_ index: Int) -> Void

class AlertPopUpViewController: UIViewController {

    var completionBlock: alertViewCompletionBlock?
    
    @IBOutlet weak var alertLabel: UILabel!
    
    //MARK: - UIViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Helper Methods

    func getRootController() -> AnyObject {
        
        var rootViewController = UIApplication.shared.delegate?.window??.rootViewController as AnyObject
        
        if (rootViewController is(UINavigationController)) {
            rootViewController = ((rootViewController as? UINavigationController)?.viewControllers[0])!
        }
        
        return rootViewController
    }
    
    func dismiss() {
        self.dismiss(animated: false, completion: nil)
        
    }
   
    //MARK: Public Methods
    
    func showCommonPopup(with block: @escaping alertViewCompletionBlock, labelTitle title1: String) {
        
        self.view .layoutIfNeeded()
        
        UIView .animate(withDuration: 3.0) {
            self.view .layoutIfNeeded()
            self.modalPresentationStyle = UIModalPresentationStyle.custom
            self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal;
            
            self.getRootController().present(self, animated: false, completion: {() -> Void in
                self.alertLabel.text = title1
                
            })
            self.completionBlock = block
        }
    }
    
    //MARK: - UIButton Action Handling
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        
        self.dismiss()
        self.completionBlock!(1)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
        self.dismiss()
        self.completionBlock!(0)
    }
    
    //MARK: - Memory Handling
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
