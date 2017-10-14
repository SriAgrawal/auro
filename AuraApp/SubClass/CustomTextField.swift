//
//  CustomTextField.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/11/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        logInfo(self.placeholder ?? "empty placeholder")
        logInfo(self.text ?? "empty")

        if self.placeholder == "Search by keyword" {
            return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        }else if self.placeholder == "Address(Optional)"{
            return CGRect(x: bounds.origin.x+18, y: bounds.origin.y, width: bounds.width-50, height: bounds.height)
        }
        else {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        if self.placeholder == "Search by keyword" {
            return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        }else if self.placeholder == "Address(Optional)"{
            return CGRect(x: bounds.origin.x+18, y: bounds.origin.y, width: bounds.width-50, height: bounds.height)
        }
        else {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        if self.placeholder == "Search by keyword" {
            return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        }else if self.placeholder == "Address(Optional)"{
            return CGRect(x: bounds.origin.x+18, y: bounds.origin.y, width: bounds.width-50, height: bounds.height)
        }
        else {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        self.autocorrectionType = UITextAutocorrectionType.no
//        let color = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
//        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName : color])
        //self.font = UIFont.textBookFont(fontSize: 20)
        // self.textAlignment = .center
    }
    
    open override func draw(_ rect: CGRect) {
        self.layer.borderColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.frame.size.height / 2
        let color = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName : color])
        //self.layer.borderWidth = 1.0
        
    }
    }
    


