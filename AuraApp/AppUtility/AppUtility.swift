//
//  AppUtility.swift
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 04/04/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

import UIKit

// MARK: - Globals

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let mainDashBoardStoryboard = UIStoryboard(name: "MainDashBoard", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let botChatStoryboard = UIStoryboard(name: "BotChat", bundle: nil)
let healthSectionCustomTabBarStoryboard = UIStoryboard(name: "HealthSectionCustomTabBar", bundle: nil)
let userProfileStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
let documentSectionStoryboard = UIStoryboard(name: "DocumentSection", bundle: nil)

let kAppColor = RGBA(r: 49, g: 118, b: 239, a: 1)
let kSeparatorColor = RGBA(r: 230, g: 230, b: 230, a: 1)

let isDeviceHasCamera = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
let defaults = UserDefaults.standard

let kWindowWidth = UIScreen.main.bounds.size.width
let kWindowHeight = UIScreen.main.bounds.size.height
let kAppName = "eKinCare"
let kRupeeUniCode = "\u{20B9}"

var currentTimestamp: String {
    return "\(Date().timeIntervalSince1970)"
}

// MARK: - Useful functions

func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func delay(delay: Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

// custom log

func logInfo(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    
    Debug.log(message)
}

func setHeightWithText(strText: String, width: CGFloat, fontName: UIFont) -> Int {
    
    let dateStringSize: CGRect = strText.boundingRect(with: CGSize(width: CGFloat(kWindowWidth - width), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontName], context: nil)
    
    return Int(dateStringSize.size.height)
}

func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
   
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
   
    let now = NSDate()
    
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}

//get story board

//  let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)


class AppUtility: NSObject {
    
    class func deviceUDID() -> String {
        
        var udidString = ""
        
        if let udid = UIDevice.current.identifierForVendor?.uuidString {
            udidString = udid
        }
        
        return udidString
    }
    
    // Date from unix timestamp from Date
    class func date(timestamp: Double) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    class func getImageFromColor(_ color:UIColor) -> UIImage {
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img;
    }
   class func getStoryBoard(storyBoardName: String) -> UIStoryboard {
        return  UIStoryboard(name: storyBoardName, bundle:nil)
    }

    class func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
   class func getDateFromString(dateStr:String) -> Date {
        
        if dateStr.length != 0 {
            
            let dateTimeStamp = NSDate(timeIntervalSince1970:Double(dateStr)!/1000)  //UTC time

            return dateTimeStamp as Date
        }
    
        return Date()
        
    }
    
    class func getDateFromUTC(dateStr:String) -> Date {
        
        if dateStr.length != 0 {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.init(abbreviation: "UTC")
            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
            return formatter.date(from: dateStr)!

        }
        
        return Date()
    }

}

//dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
