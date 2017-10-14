//
//  ContactDetailInfo.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 23/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ContactDetailInfo: NSObject {

    var profileImage : String = ""
    var friendNameString : String = "dsfsd"
    var friendStatusString : String = "dsfgd"
    var statusImage : String = ""
    var activeTimeString : String = "sdsa"
    var commentString : String = "sdsad"
    var isSelectedIndex : Bool = true
    class func getContactDetailListArray(responceArray : Array<Dictionary<String,String>>)->Array<ContactDetailInfo>
    {
        var contactDetailInfoArray = Array<ContactDetailInfo>()
        for ContactItem in responceArray{
            let contactObj = ContactDetailInfo()
            contactObj.profileImage = ContactItem["profileImage"]!
            contactObj.friendNameString = ContactItem["friendName"]!
            contactObj.friendStatusString = ContactItem["friendProfileStatus"]!
            contactObj.activeTimeString = ContactItem["friendActiveTime"]!
            contactObj.commentString = ContactItem["comment"]!
            contactObj.statusImage = ContactItem["friendStatusImage"]!
            
            contactDetailInfoArray.append(contactObj)
        }
        return contactDetailInfoArray
    }
 
}
