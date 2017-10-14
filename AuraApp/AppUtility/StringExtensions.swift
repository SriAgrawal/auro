//
//  StringExtensions.swift
//  Wheelz
//
//  Created by Probir Chakraborty on 12/07/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import Foundation
import UIKit

func presentAlert(_ titleStr : String?,msgStr : String?,controller : AnyObject?){
    DispatchQueue.main.async(execute: {
        let alert=UIAlertController(title: titleStr, message: msgStr, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil));
        
        //event handler with closure
        controller!.present(alert, animated: true, completion: nil);
    })
}

func presentAlertWithOptions(_ title: String, message: String,controller : AnyObject, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
    controller.present(alert, animated: true, completion: nil)
    // alert.view.tintColor = UserDefaults.standard.colorForKey("color")! as UIColor
    
    //        instance.topMostController()?.presentViewController(alert, animated: true, completion: nil)
    return alert
}

func getStringFromDate(date: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm a"
    let myString = formatter.string(from: date)
    let yourDate: Date? = formatter.date(from: myString)
    
    let updatedString = formatter.string(from: yourDate!)
    return updatedString
    
}

func getTimeStringFromDate(date: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let myString = formatter.string(from: date)
    let yourDate: Date? = formatter.date(from: myString)
    
    let updatedString = formatter.string(from: yourDate!)
    return updatedString
    
}

private extension UIAlertController {
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertActionStyle, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        
        
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}

extension String {
    
    func contains(_ string: String) -> Bool {
        return self.range(of: string) != nil
    }
    
    func substringFromIndex(_ index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    func substringToIndex(_ index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    func trimWhiteSpace () -> String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    
    func isValidMobileNumber() -> Bool
    {
        
        let mobileNoRegEx = "^[0-9]+$"
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluate(with: self)
    }
    
    
//    func isValidMobileNumber() -> Bool {
//        let mobileNoRegEx = "^((\\+)|(00)|(\\*)|())[0-9]{3,20}((\\#)|())$"
//        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
//        return mobileNoTest.evaluate(with: self)
//    }
    
    func isValidUserName() -> Bool {
        let nameRegEx = "^[a-zA-Z0-9\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        let passwordRegEx = "^[A-Za-z0-9]+(?=.*?)(?=.*?[#?!@$%^&*-]).{8,16}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }

    func isEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        print(emailTest.evaluate(with: self))
        return emailTest.evaluate(with: self)
    }
    
    func containsAlphaNumericOnly() -> Bool {
        let nameRegEx = "^[a-zA-Z0-9\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func containsNumberOnly() -> Bool {
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func containsAlphabetsOnly() -> Bool {
        let nameRegEx = "^[a-zA-Z\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        
        let nameRegEx = "^[a-zA-Z ]+$"
        _ = self.trimmingCharacters(in: .whitespaces)
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func dateFromString(_ format:String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            logInfo("Unable to format date")
        }
        
        return nil
    }
    
    
//    func md5() -> String {
//        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
//        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
//            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
//        }
//        
//        var digestHex = ""
//        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//            digestHex += String(format: "%02x", digest[index])
//        }
//        
//        return digestHex
//    }
    
    //>>>> removes all whitespace from a string, not just trailing whitespace <<<//
    func removeWhitespace() -> String {
        return self.replaceString(" ", withString: "")
    }
    
    //>>>> Replacing String with String <<<//
    func replaceString(_ string:String, withString:String) -> String {
        return self.replacingOccurrences(of: string, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func getAttributedString(_ string_to_Attribute:String, color:UIColor, font:UIFont) -> NSAttributedString {
        
        let range = (self as NSString).range(of: string_to_Attribute)
        
        let attributedString = NSMutableAttributedString(string:self)
        
        // multiple attributes declared at once
        let multipleAttributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: font,
            ]
        
        attributedString.addAttributes(multipleAttributes, range: range)
        
        return attributedString.mutableCopy() as! NSAttributedString
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}
