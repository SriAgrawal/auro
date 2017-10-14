//
//  ChatInfo.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ChatInfo: NSObject {

    var senderImage : URL?
    var senderId : String = ""
    var senderName : String = ""

    var recieverImage : URL?
    var recieverId : String = ""
    var recieverName : String = ""

    var messageString : String = ""
    var lastMessageString : String = ""

    var messageType : String = ""

    var attachedImage : URL?

    var chatDateTimeString : String = ""

    var chatArray = [ChatInfo]()
    
    var mobileDataBool : Bool = false
    var wifiBool : Bool = false
    var roamingBool : Bool = false    

   class func getdataUsage(responceArray : Array<Dictionary<String,AnyObject>>) -> ChatInfo {
    
    let dataUsageObj = ChatInfo()

    if responceArray.count != 0 {
        
        let dict = responceArray.first
        
        dataUsageObj.mobileDataBool = dict!.validatedValue(KMobileData, expected: Bool() as AnyObject) as! Bool
        dataUsageObj.wifiBool = dict!.validatedValue(KConnectedToWifi, expected: Bool() as AnyObject) as! Bool
        dataUsageObj.roamingBool = dict!.validatedValue(KWhenRoaming, expected: Bool() as AnyObject) as! Bool
        
    }        
        return dataUsageObj
    }
    
    class func getChistoryArray(responceDict : Dictionary<String,AnyObject>) -> ChatInfo {
        
        let chatDataObj = ChatInfo()

        //var chatArray = [ChatInfo]()
        
        let commentArray = responceDict.validatedValue("data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
        
        for dict in commentArray {
            
            let chatObj = ChatInfo()
            
            chatObj.senderId = dict.validatedValue("message_sender", expected: "" as AnyObject) as! String
            chatObj.recieverId = dict.validatedValue("message_receiver", expected: "" as AnyObject) as! String
            
            chatObj.messageType = dict.validatedValue("type_of_messages", expected: "" as AnyObject) as! String

            if chatObj.messageType == "text" {
                chatObj.messageString = dict.validatedValue("messages", expected: "" as AnyObject) as! String

            } else {
                let attachedUrlString = dict.validatedValue("messages", expected: "" as AnyObject) as! String
                chatObj.attachedImage = URL(string:attachedUrlString)
            }
            
            chatDataObj.chatArray.append(chatObj)
            
        }
        
        let userProfileDict = responceDict.validatedValue("sender_profile", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String,AnyObject>
        
        chatDataObj.senderName = userProfileDict.validatedValue("user_name", expected: "" as AnyObject) as! String
        
        let profileUrlString = userProfileDict.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
        chatDataObj.senderImage = URL(string:profileUrlString)
        
        
        let receiverProfileDict = responceDict.validatedValue("receiver_profile", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String,AnyObject>
        
        chatDataObj.recieverName = receiverProfileDict.validatedValue("user_name", expected: "" as AnyObject) as! String
        
        let receiverProfileUrlString = receiverProfileDict.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
        chatDataObj.recieverImage = URL(string:receiverProfileUrlString)
        

        return chatDataObj
    }

    class func getChatListArray(responceDict : Dictionary<String,AnyObject>) -> Array<ChatInfo> {
        
        var chatArray = [ChatInfo]()
        
        let chatListArray = responceDict.validatedValue("data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
        
        for dict in chatListArray {
            
            let chatObj = ChatInfo()
            
            chatObj.senderId = dict.validatedValue("message_sender", expected: "" as AnyObject) as! String
            chatObj.recieverId = dict.validatedValue("message_receiver", expected: "" as AnyObject) as! String
            
            chatObj.messageType = dict.validatedValue("last_message_type", expected: "" as AnyObject) as! String
    
            chatObj.lastMessageString = dict.validatedValue("last_message", expected: "" as AnyObject) as! String
                
            let str = dict.validatedValue("chat_time", expected: "" as AnyObject) as! String
            
            if str.length != 0 {
                
                let date = AppUtility.getDateFromString(dateStr: str) as Date
                
                chatObj.chatDateTimeString = timeAgoSinceDate(date: date as NSDate, numericDates: true)
                
                //chatObj.chatDateTimeString = date.getDateTimeString()
            }
            
            let userProfileDict = dict.validatedValue("chat_receiver_user_profile", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String,AnyObject>
            
            chatObj.recieverName = userProfileDict.validatedValue("user_name", expected: "" as AnyObject) as! String
            
            let profileUrlString = userProfileDict.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
            chatObj.recieverImage = URL(string:profileUrlString)
            
            chatArray.append(chatObj)
            
        }
        
        return chatArray
    }
    
}
