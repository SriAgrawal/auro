//
//  NotificationInfo.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 14/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class NotificationInfo: NSObject {
    
    var notificationMessageString : String = ""
    var notificationTime : String = ""
    var notificationId : String = ""
    var notificationsenderId : String = ""
    var notificationsenderName : String = ""

    var profileImage : URL?
    var notificationType : String = ""

    
    class func getNotificationListArray(responceDict : Dictionary<String,AnyObject>) -> Array<NotificationInfo> {
        
        
        var notificationListArray = [NotificationInfo]()
        
        let notificationArray = responceDict.validatedValue("notification", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
        
        for dict in notificationArray {
            
            let notificationObj = NotificationInfo()
            
            notificationObj.notificationId = dict.validatedValue("id", expected: "" as AnyObject) as! String
            notificationObj.notificationType = dict.validatedValue("notification_type", expected: "" as AnyObject) as! String
            notificationObj.notificationMessageString = dict.validatedValue("message", expected: "" as AnyObject) as! String
            notificationObj.notificationsenderId = dict.validatedValue("notification_sender", expected: "" as AnyObject) as! String
            notificationObj.notificationsenderName = dict.validatedValue("notification_sender_profile", expected: "" as AnyObject) as! String

            let timeString = dict.validatedValue("created_at", expected: "" as AnyObject) as! String
            notificationObj.notificationTime = AppUtility.getDateFromUTC(dateStr: timeString).getDateTimeString()
            
            let profileUrlString = dict.validatedValue("notification_sender_image", expected: "" as AnyObject) as! String
            notificationObj.profileImage = URL(string:profileUrlString)

            notificationListArray.append(notificationObj)
            
        }

        return notificationListArray
    }

}
