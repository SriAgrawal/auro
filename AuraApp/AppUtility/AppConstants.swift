//
//  AppConstants.swift
//  Smoogin
//
//  Created by Raj Kumar Sharma on 01/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import UIKit

let logOutTitle         = "Log out"
let logOutSubTitle      = "Are you sure you wish to log out?"

let commonColCellSectionInsets = UIEdgeInsets(top: 2.0, left: 12.0, bottom: 12.0, right: 12.0)


//@@@ NSNotificationCenter

let emailMaxLength                  =       60
let passwordMaxLength               =       20
let subjectMaxLength                =       90
let addressSniptMaxLength           =       32

let passwordMinLength               =       6
let nameMaxLength                   =       60
let phoneNumberMaxLength            =       15
let institueNameMaxLength           =       60
let feedbackMaxLength               =       2000
let addressMaxLength                =       120
let referralMaxLength               =       12

//@@ User Default
let pAppNetworkMode                 = "appNetworkMode" // 0:not rechable 1:Wifi 2:Mobile n/w
let pUserId                         = "userId"
let pIsProfileComplete              = "isProfileComplete"
let pChatId              = "chatId"


//API Names

let Klogin                  = "add_number"
let KOtpVerification        = "verify_otp"
let KresendOtp              = "resend_otp"
let Kstatic_pages           = "terms_condition"
let Kprivacy_policies       = "privacy_policy"
let KcompleteProfile        = "create_profile"
let KChangeNumberResendOTP   = "resend_change_otp"

let KpostFeedback           = "feedback"
let KuploadPhoto            = "post_image"
let KAddProfile             = "create_multiple_profile"

let Khome                   = "home"
let KupdateInformation      = "update_profile"
let KgetProfile             = "profile"
let KmyPage                 = "mypage"
let KchangeNumber           = "change_number"
let KchangeNumberVerify     = "change_number_verify"
let KCreateMultipleProfile  = "create_multipleprofile"

let KViewMultipleprofile    = "view_multipleprofile"
let KDeleteMultipleprofile  = "delete_multipleprofile"

let KGetProfiletype         = "get_profiletype"
let KAuraContacts           =  "user_registered_contacts"
let KAllContacts            =  "all_contacts"

let KViewContactProfile             = "user_friend_profile"

let KViewComment                    = "view_comment"
let KComment                        = "comment"
let KDataUsage                      = "Create_DataUsage"
let KViewDataUsage                  = "view_data_usage"

let KViewLocation                   = "view_location"
let KAddFriend                      = "requestsend"
let KShareLocation                  = "location_status"
let KNotificationStatus             = "notification_status"
let KContactsShare                  = "contacts_share_push"
let KFriendshipStatus                  = "friendship_status"

let KUnfriend                       = "unfriend"

let KUserChat                       = "user_chat"
let KChatHistory                    = "chat_history"
let KChatList                       = "chatlist"
let KAddFriendByCategory            = "add_friend_by_category"
let KNotificationList               = "notification_list"
let KDeleteSingleNotification       = "Clear_single_notification"
let KDeleteAllNotification          = "Clear_all_notification"
let KAcceptFriendRequest            = "friend_req_add_category"
let KRejectFriendRequest            = "delete_friend"
let KAccountDelete                  =  "delete_account"
let KInvitOnAura                    = "invite_on_aura"
let KLogout                         = "logout"

//Parameters Names

let kJWTToken = "jwtToken"
let pToken = "token"
let pStatusCode = "status"
let pError = "error"

//Other Constants

let KId                                 = "id"
let KUser_Id                            = "user"
let KPost_Id                            = "post_id"

let KApi_Key                            = "api_key"

let KCountry                            = "country_name"
let KCountryCode                        = "country_code"
let KMobileNumber                       = "mobile_number"
let KNewMobileNumber                    = "new_number"
let Kdevice_token                       = "device_token"
let KresponseCode                       = "responseCode"
let KresponseMessage                    = "responseMessage"
let Kname                               = "user_name"
let Kemail                              = "user_email"
let KStatus                             = "user_status"
let KprofileType                        = "profiles_type"
let KcategoryProfileType                = "profile_type_name"
let KcontactList                        = "contact_list"
let KContactImage                       = "user_profile_image"
let KcontactName                        = "user_name"
let KcontactNumber                      = "mobile_number"
let KcontactStatus                      = "user_status"
let KcontactId                          = "user"

let Kaddress                            = "address"
let Klongitude                          = "lat"
let Klattitude                          = "lng"
let KprofileImage                       = "user_profile_image"
let Kdevice_type                        = "device_type"
let KVerificationCode                   = "mobile_verification_code"

let KUserPost                           = "user_post"
let KTag                                = "tag"
let KAttachedImage                           = "attached_image"

let Kfeedback                           = "feedback"


let KUserInfo                           = "userInfo"
let KpostImage                          = ""

let KRegister_data                      = "register_data"
let KProfile_data                      = "profile_data"
let KStatus_on_post                      = "status_on_post"
let KPost_time                      = "post_time"
let KFriendId                            = "friend_id"
let KFriendRequestSender                            = "friend_request_sender"


let KMobileData                            = "mobile_data"
let KConnectedToWifi                            = "connected_to_wifi"
let KWhenRoaming                            = "when_roaming"

let KProfileTypeName                                = "profile_type_name"

//@@@ Validation strings

let blankEmail                      = "Please enter email."
let invalidEmail                    = "Please enter valid email."
let blankPassword                   = "Please enter password."
let minPassword                     = "Password must be at least 8 characters long."
let blankName                       = "Please enter your name."
let blankFirstName                  = "Please enter first name."
let blankLastName                   = "Please enter last name."
let blankMobileNumber               = "Please enter phone number."
let invalidMobileNumber             = "Please enter valid phone number."
let blankCurrentPassword            = "Please enter current password."
let blankNewPassword                = "Please enter new password."
let blankRePassword                 = "Please re-type new password."
let minCurrentPassword              = "Please enter valid current password."
let minNewPassword                  = "Please enter valid new password."
let minRePassword                   = "Please re-type valid new password."
let mismatchNewAndRePassword        = "Re-type password must match the new password entry."
let mismatchPassowrdAndConfirmPassword = "Confirm password must match with password."

//Success
let forgotPasswordSuccess = "An email has been sent to your email address. Follow the directions in the email to reset your password."


class AppConstants: NSObject {
    
}
