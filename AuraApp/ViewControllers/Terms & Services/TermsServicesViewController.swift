//
//  TermsServicesViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 22/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class TermsServicesViewController: UIViewController {
    @IBOutlet weak var navigationTitleLabel: UILabel!
    var isController = Bool()
    
    @IBOutlet weak var termsWebView: UIWebView!
    //MARK : UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - HelperMethod
    
    func initialMethod()
    {
        if (isController)
        {
            self.navigationTitleLabel.text = "Terms & Services"
           self.callApiMethodToStaticContent(type: 0)

        }
        else
        {
            self.navigationTitleLabel.text = "Privacy Policy"
            self.callApiMethodToStaticContent(type: 1)

        }
    }
   
    
    //MARK: -API for TermsCondition
    func callApiMethodToStaticContent(type:Int) -> Void {
        
        ServiceHelper.request(params: [:], method: .get, apiName: (type == 0) ? Kstatic_pages : Kprivacy_policies, hudType: .simple) { (result, error, httpCode) in
            
            if error == nil {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200 {
                        
                        let dic = response.validatedValue("content", expected: NSDictionary()) as! Dictionary<String, AnyObject>
                        let strContent = dic.validatedValue("content", expected: "" as AnyObject) as! String
                        self.termsWebView.loadHTMLString(strContent, baseURL: nil);
                        logInfo(strContent)
                
                    } else {
                        _ = AlertController.alert("", message: response.validatedValue("message", expected: AnyObject.self as AnyObject) as! String)
                }
            }
            }
            else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
}
