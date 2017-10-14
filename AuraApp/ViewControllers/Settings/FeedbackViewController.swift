//
//  FeedbackViewController.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/18/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITableViewDelegate,UITextViewDelegate {
    var errorRowNo = Int()
    var isEmpty = true
    @IBOutlet weak var feedbackTableView: UITableView!
    @IBOutlet var feedbackFooterView: UIView!
    @IBOutlet var feedbackHeaderView: UIView!
    @IBOutlet weak var feedbackSendButton: UIButton!
    @IBOutlet weak var feedbackTextView: UITextView!
    
    var feedObj = AUserInfo()
    
    //MARK: - ViewLifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    
    //MARK: HelperMethods
    func initialMethod()
    {
        self.feedbackTableView.tableFooterView = feedbackFooterView
        self.feedbackTableView.tableHeaderView = feedbackHeaderView
        self.feedbackTextView.text = feedObj.feedbackString
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - TextViewDelegateMethods
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.tag == 100
        {
            feedObj.feedbackString = textView.text
        }
    }
    //MARK: - UIButton Actions.
    @IBAction func feedbackSendBtnAction(_ sender: UIButton) {
        self.view .endEditing(true)
        if  isallFieldVerified(){
            self.callApiMethodToFeedback()
            
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Validation Methods
    
    func isallFieldVerified() -> Bool {
        var isValid: Bool = false
        if feedObj.feedbackString.trimWhiteSpace().length == 0 {
            
            presentAlert("", msgStr: "Please enter feedback", controller: self)
        }
        else{
            isValid = true
        }
        return isValid
    }
    
    //MARK: WebServiceMethod For Feedback
    
    func callApiMethodToFeedback() {
        
        guard let userId = defaults.value(forKey: pUserId) as? String else {
            return
        }
        
        let paramDict = [
            KUser_Id : userId,
            Kfeedback : feedObj.feedbackString,
            ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: KpostFeedback, hudType: .simple) { (result, error, httpCode) in
            
            let response = result as! Dictionary<String,AnyObject>
            
            if error == nil {
                
                if Int(response.validatedValue("status", expected: NSNumber.self) as! NSNumber) == 200  {
                    
                    _ =     presentAlertWithOptions("", message: response.validatedValue("message", expected: "" as AnyObject) as! String, controller: self, buttons: ["OK"], tapBlock: { (UIAlertAction, Int) in
                        
                        _ =    self.navigationController?.popViewController(animated: true)
                    })
                    
                } else {
                    _ = AlertController.alert("", message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                }
            } else {
                _ = AlertController.alert("", message: "\(error!.localizedDescription)")
                
            }
        }
    }
    
    
}
