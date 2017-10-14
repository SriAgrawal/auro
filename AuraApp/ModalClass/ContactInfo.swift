//
//  ContactInfo.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 12/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ContactInfo: NSObject {

    var contactNameString : String = ""
    var contactUserId : String = ""
    var contactNumber : String = ""
    var contactStatus : String = ""
   
    var contactImage = UIImage()
    
    var contactImageUrl : URL?

    var isCheckedBox = Bool()
    var isFriend = Bool()

    var avatar: UIImage?
    
    var unregisteredUseresArray = [ContactInfo]()
    
    //parse contact
    class func getContactListArray(postInfo: Array<Dictionary<String,AnyObject>>) -> Array<ContactInfo> {
        
        var contactInfoArray = [ContactInfo]()
        
        for userInfo in postInfo {
            
            let contactObj = ContactInfo()
            
            contactObj.contactNumber = userInfo.validatedValue(KcontactNumber, expected: "" as AnyObject) as! String
            
            let userProfileArray = userInfo.validatedValue("user_profile", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
            
            if userProfileArray.count != 0 {
                
                let userProfileDict = userProfileArray.first
                
                let contactImageUrlString = userProfileDict?.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
                contactObj.contactImageUrl = URL(string:contactImageUrlString)
                
                contactObj.contactNameString = userProfileDict?.validatedValue(KcontactName, expected: "" as AnyObject) as! String
                contactObj.contactUserId = userProfileDict?.validatedValue(KUser_Id, expected: "" as AnyObject) as! String
                contactObj.contactStatus = userProfileDict?.validatedValue(KcontactStatus, expected: "" as AnyObject) as! String
            }
            
            contactInfoArray.append(contactObj)
        }
        
        return contactInfoArray
    }
    

    class func getAllContactArray(conatctInfo: Dictionary<String,AnyObject>) -> Array<ContactInfo> {
        
        var contactInfoArray = [ContactInfo]()
        
        let unrgisterarray = conatctInfo.validatedValue("Unregistered_Users", expected: [] as AnyObject) as! Array<String>
        
        for str in unrgisterarray {
            
            let contactObj = ContactInfo()

            contactObj.contactNumber = str
            
            contactInfoArray.append(contactObj)
        }
        
        return contactInfoArray
    }

}
