//
//  AUserInfo.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/11/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class AUserInfo: NSObject {
    
    var userId = String()
    var email = String()
    var password = String()
    
    var termsAndConditions = Bool()
    
    var userProfileImage : URL?
    var mobileNumber = String()
    var confirmPassword = String()
    var oldPassword = String()
    var newPassword = String()
    var desc = String()
    var socialType = String()
    var name = String()
    var status = String()
    var bodyMassage = String()
    var dateOfBooking = String()
    var title = String()
    var descriptionView = String()
    var team = String()
    var location = String()
    var phoneBook = String()
    var emailOrMobileNumber = String()
    //User Delivery Address Info
    var pincode = String()
    var postcode = String()
    var address = String()
    var longitude = Double()
    var lattitude = Double()
    var country = String()
    var landmark = String()
    var strCommonError = ""
    var cellicularName = String()
    var cellicularCredentialArray = Array<AUserInfo>()
    var local = ""
    var googleDrive = ""
    var size = ""
    var account = ""
    
    var feedbackString : String = ""
    
    var avatar: UIImage?
  
    
    //Payment Method
    var paymentMethod = String()
    
    //Add multiple profile
    var categoryProfileImage : URL?
    
    var categoryProfileStatusString : String  = ""
    var categoryProfileTypeString : String = ""
    var categoryId = Int()
    
    class func getDataOfProfile(userInfo: Dictionary<String, AnyObject>?) -> AUserInfo {
        
        let userObj = AUserInfo()
        
        userObj.name = userInfo?.validatedValue(Kname, expected: "" as AnyObject) as! String
        userObj.email = userInfo?.validatedValue(Kemail, expected: "" as AnyObject) as! String
        userObj.address = userInfo?.validatedValue(Kaddress, expected: "" as AnyObject) as! String
        userObj.mobileNumber = userInfo?.validatedValue(KMobileNumber, expected: "" as AnyObject) as! String
        userObj.status  = userInfo?.validatedValue(KStatus, expected: "" as AnyObject)as! String
        let userProfileImageUrlString = userInfo?.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
        userObj.userProfileImage = URL(string:userProfileImageUrlString)
        return userObj
    }

    class func getProfileListArray(responceArray : Array<Dictionary<String,AnyObject>>) -> Array<AUserInfo> {
        
        var profileInfoArray = Array<AUserInfo>()
        
        for profileItem in responceArray {
            
            let profileObj = AUserInfo()
            
            profileObj.categoryProfileStatusString = profileItem.validatedValue("status", expected: "" as AnyObject) as! String
            profileObj.categoryProfileTypeString = profileItem.validatedValue("profile_type_name", expected: "" as AnyObject) as! String
            
            let userProfileImageUrlString = profileItem.validatedValue("profile_image", expected: "" as AnyObject) as! String
            profileObj.categoryProfileImage = URL(string:userProfileImageUrlString)
            
            profileInfoArray.append(profileObj)
        }
        
        return profileInfoArray
    }
    
    class func getProfileCategory(responceArray : Array<Dictionary<String,AnyObject>>) -> Array<AUserInfo> {
        
        var profileInfoArray = Array<AUserInfo>()
        
        for profileItem in responceArray {
            
            let profileObj = AUserInfo()
        
            profileObj.categoryId = profileItem.validatedValue("id", expected: Int() as AnyObject) as! Int
            profileObj.categoryProfileTypeString = profileItem.validatedValue("profiles_type", expected: "" as AnyObject) as! String
            
            profileInfoArray.append(profileObj)
        }
        
        return profileInfoArray
    }
}
