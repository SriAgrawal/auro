//
//  HomeInfo.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 16/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class HomeInfo: NSObject {
    
    var userNameString : String = ""
    var userEmailString : String = ""
    var userStatusString : String = ""
    var userAddress : String = ""
    var userIdString : String = ""
    var userProfileImage : URL?
    
    var friendProfileImage : URL?
    var statusImage : URL?

    var friendNameString : String = ""
    var friendEmailString : String = ""
    var friendAddressString : String = ""
    var friendStatusString : String = ""
    var friendIdString : String = ""

    var friendPostArray = [HomeInfo]()
    
    var postIdString : String = ""

    var activeTimeString : String = ""
    var numberOfComment = Int()
  
    var friendStatus : Bool = false
    var notificationOnOffStatus : Bool = false

    
    var isSelectedIndex : Bool = true
    var commentString : String = ""

    var latitude = Double()
    var longitude = Double()
    
    var profileImage : URL!

    var image : URL?

    var selectedPostImage : String  = ""

    var postImage: UIImage?

    var userMobileNumber : String = ""

    class func getHomePageListArray(responceDict : Dictionary<String,AnyObject>) -> HomeInfo {
    
        let homeInfo = HomeInfo()
       
        let dict = responceDict.validatedValue("user_data", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String, AnyObject>
        
        let userProfileArray = dict.validatedValue("user_profile", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>

        if !(userProfileArray.count == 0) {
            
            let userData = userProfileArray.first
            homeInfo.userNameString = userData?.validatedValue("user_name", expected: "" as AnyObject) as! String
            
            UserDefaults.standard.set(homeInfo.userNameString, forKey: Kname)

            homeInfo.userEmailString = userData?.validatedValue("user_email", expected: "" as AnyObject) as! String
            homeInfo.userStatusString = userData?.validatedValue("user_status", expected: "" as AnyObject) as! String
            homeInfo.userAddress = userData?.validatedValue("address", expected: "" as AnyObject) as! String
            
            let userProfileImageUrlString = userData?.validatedValue("profile_image", expected: "" as AnyObject) as! String
            homeInfo.userProfileImage = URL(string:userProfileImageUrlString)
        }

        let postArray = responceDict.validatedValue("user_post_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
        
        for homePageItem in postArray {
            
            let homePageObj = HomeInfo()
            
            let statusUrlString = homePageItem.validatedValue("user_post_image", expected: "" as AnyObject) as! String
            homePageObj.statusImage = URL(string:statusUrlString)
            
            let str = homePageItem.validatedValue(KPost_time, expected: "" as AnyObject) as! String
            let date = AppUtility.getDateFromString(dateStr: str) as Date
            homePageObj.activeTimeString  = timeAgoSinceDate(date: date as NSDate, numericDates: true)
            
//            homePageObj.activeTimeString = date.getDateTimeString()

            homePageObj.friendStatusString = homePageItem.validatedValue("status_on_post", expected: "" as AnyObject) as! String
            homePageObj.friendIdString = homePageItem.validatedValue("user", expected: "" as AnyObject) as! String
            homePageObj.postIdString = homePageItem.validatedValue("id", expected: "" as AnyObject) as! String
            homePageObj.numberOfComment = homePageItem.validatedValue("comment_count", expected: Int() as AnyObject) as! Int

            let friendDetailDict = homePageItem.validatedValue("user_detail", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String, AnyObject>

            let imageUrlString = friendDetailDict.validatedValue("user_profile_image", expected: "" as AnyObject) as! String
            homePageObj.friendProfileImage = URL(string:imageUrlString)
            
            homePageObj.friendNameString = friendDetailDict.validatedValue("user_name", expected: "" as AnyObject) as! String
            
            homeInfo.friendPostArray.append(homePageObj)
        }
        
        return homeInfo
  
    }
    
   //parse my page data
    class func getDataOfMypage(postInfo: Array<Dictionary<String,AnyObject>>) -> Array<HomeInfo> {
        
        var homeInfoArray = [HomeInfo]()

        if postInfo.count != 0 {
            
            for userInfo in postInfo {
                
                let myPageObj = HomeInfo()
                
                let statusUrlString = userInfo.validatedValue("user_post", expected: "" as AnyObject) as! String
                myPageObj.statusImage = URL(string:statusUrlString)
                
                myPageObj.userStatusString = userInfo.validatedValue("status_on_post", expected: "" as AnyObject) as! String
                
                let str = userInfo.validatedValue(KPost_time, expected: "" as AnyObject) as! String
                let date = AppUtility.getDateFromString(dateStr: str) as Date
                myPageObj.activeTimeString  = timeAgoSinceDate(date: date as NSDate, numericDates: true)

                //myPageObj.activeTimeString = date.getDateTimeString()
                
                myPageObj.numberOfComment = userInfo.validatedValue("comment_count", expected: Int() as AnyObject) as! Int
                
                myPageObj.postIdString = userInfo.validatedValue("id", expected: "" as AnyObject) as! String

                let userDict = userInfo.validatedValue("user_detail", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String, AnyObject>
                
                myPageObj.userNameString = userDict.validatedValue(Kname, expected: "" as AnyObject) as! String
                
                let imageUrlString = userDict.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
                myPageObj.userProfileImage = URL(string:imageUrlString)
                
                homeInfoArray.append(myPageObj)
                
            }
        }
        
             return homeInfoArray
    }

    class func getConatctProfileArray(responceDict : Dictionary<String,AnyObject>) -> HomeInfo {
        
        let homeInfo = HomeInfo()
        
        homeInfo.friendStatus = responceDict.validatedValue("friend_status", expected: Bool() as AnyObject) as! Bool
        homeInfo.notificationOnOffStatus = responceDict.validatedValue("notification_status", expected: Bool() as AnyObject) as! Bool

        let dict = responceDict.validatedValue("Post_data", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String, AnyObject>
        
        homeInfo.userMobileNumber = dict.validatedValue("mobile_number", expected: "" as AnyObject) as! String

        let userProfileArray = dict.validatedValue("user_profile", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
        
        let userData = userProfileArray.first
        homeInfo.userIdString = userData?.validatedValue("user", expected: "" as AnyObject) as! String
        homeInfo.userNameString = userData?.validatedValue("user_name", expected: "" as AnyObject) as! String
        homeInfo.userEmailString = userData?.validatedValue("user_email", expected: "" as AnyObject) as! String
        homeInfo.userStatusString = userData?.validatedValue("user_status", expected: "" as AnyObject) as! String
        homeInfo.userAddress = userData?.validatedValue("address", expected: "" as AnyObject) as! String
        
        let userProfileImageUrlString = userData?.validatedValue("profile_image", expected: "" as AnyObject) as! String
        homeInfo.userProfileImage = URL(string:userProfileImageUrlString)
        
        homeInfo.latitude = userData?.validatedValue("lat", expected: Double() as AnyObject) as! Double
        homeInfo.longitude = userData?.validatedValue("lng", expected: Double() as AnyObject) as! Double

        let postArray = dict.validatedValue("post_image", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>
        
        for homePageItem in postArray {
            
            let homePageObj = HomeInfo()
            
            homePageObj.postIdString = homePageItem.validatedValue("id", expected: "" as AnyObject) as! String

            let statusUrlString = homePageItem.validatedValue("user_post_image", expected: "" as AnyObject) as! String
            homePageObj.statusImage = URL(string:statusUrlString)
            
            homePageObj.friendStatusString = homePageItem.validatedValue("status_on_post", expected: "" as AnyObject) as! String
            homePageObj.friendIdString = homePageItem.validatedValue("user", expected: "" as AnyObject) as! String
            
            homePageObj.numberOfComment = homePageItem.validatedValue("comment_count", expected: Int() as AnyObject) as! Int
            
            let str = homePageItem.validatedValue(KPost_time, expected: "" as AnyObject) as! String
            let date = AppUtility.getDateFromString(dateStr: str) as Date
            homePageObj.activeTimeString  = timeAgoSinceDate(date: date as NSDate, numericDates: true)

            //homePageObj.activeTimeString = date.getDateTimeString()

            
            let friendDetailDict = homePageItem.validatedValue("user_detail", expected: [String:AnyObject]() as AnyObject) as! Dictionary<String, AnyObject>
            
            let imageUrlString = friendDetailDict.validatedValue("user_profile_image", expected: "" as AnyObject) as! String
            homePageObj.friendProfileImage = URL(string:imageUrlString)
            
            homePageObj.friendNameString = friendDetailDict.validatedValue("user_name", expected: "" as AnyObject) as! String
         
            homeInfo.friendPostArray.append(homePageObj)
        }
        
        return homeInfo
        
    }
    
    class func getCommentListArray(responceDict : Dictionary<String,AnyObject>) -> Array<HomeInfo> {

        var commentListArray = [HomeInfo]()
        
        let commentArray = responceDict.validatedValue("comment_data", expected: [] as AnyObject) as! Array<Dictionary<String,AnyObject>>

        for dict in commentArray {
            
            let commentObj = HomeInfo()
            
            commentObj.postIdString = dict.validatedValue("post", expected: "" as AnyObject) as! String
            commentObj.commentString = dict.validatedValue("comment", expected: "" as AnyObject) as! String
            commentObj.userIdString = dict.validatedValue("user_comment", expected: "" as AnyObject) as! String

            let commentGivenByDict = dict.validatedValue("given_bys", expected:[String:AnyObject]() as AnyObject) as! Dictionary<String,AnyObject>

            commentObj.userNameString = commentGivenByDict.validatedValue("user_name", expected: "No Name" as AnyObject) as! String

            let profileUrlString = commentGivenByDict.validatedValue(KprofileImage, expected: "" as AnyObject) as! String
            commentObj.userProfileImage = URL(string:profileUrlString)
            
            commentListArray.append(commentObj)
            
        }
        
        return commentListArray
    }

}
