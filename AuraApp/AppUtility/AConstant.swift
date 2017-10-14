//
//  AConstant.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/11/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

let BLANK_EVENTNAME = "Please enter event name."
let VALID_EVENTNAME = "Event name must be of atleast 2 characters."
let BLANK_STARTDATE = "Please enter start date & time."
let BLANK_ENDTIME = "Please enter end time."
let VALID_DESCRIPTION = "Description must be of atleast 2 characters."

let AGREE_TERMS  = "Please agree to terms and conditions."

let BLANK = ""
let BLANK_NAME = "*Please enter name."
let PROFILE_UPDATE = "Profile updated successfully."
let BLANK_OTP = "Please enter OTP."
let VALID_OTP = "Please enter valid OTP."
let EVENT_CREATE = "Event created successfully."
let PASSWORD_CHANGE = "Password changed successfully."


let VALID_NAME = "*Please enter valid name."
let MINI_NAME = "*Name must be of atleast 2 characters."
let BLANK_FIRSTNAME = "Please enter first name."
let MINI_FIRSTNAME = "First name must be of atleast 2 characters."
let BLANK_LASTNAME = "Please enter last name."
let MINI_LASTNAME = "Last name must be of atleast 2 characters."
let BLANK_EMAIL = "*Please enter email address."
let MAX_EMAIL = "*Email ID has maximum limit of 80 characters."
let BLANK_PASSWORD = "Please enter password."
let MAX_PASSWORD = "password has maximum limit of 16 characters."
let MIN_PASSWORD = "Password must be of atleast 8 characters."

let MIN_OLDPASSWORD = "Old password must be of atleast 8 characters."

let BLANK_STATUS = "*Please enter status."

let EDIT_DETAIL = "Post updated successfully."

let BLANK_CONFIRMPASSWORD = "Please enter confirm password."
let MIN_CONFIRMPASSWORD = "Confirm password must be of atleast 8 characters."
let MAX_CONFIRMPASSWORD = "Confirm password has maximum limit of 16 characters."
let VALID_FIRSTNAME = "Please enter valid first name."
let VALID_LASTNAME = "Please enter valid last name."
let VALID_EMAIL = "*Please enter valid email address."
let BLANK_MOBILENUMBER = "*Please enter mobile number."
let MAX_MOBILENUMBER = "*Mobile number has maximum limit of atleast 20 characters."
let MINI_MOBILENUMBER = "*Mobile number must be of atleast 10  characters."
let MATCH_PASSWORD = "Password and confirm password must be same."
let BLANK_DOB = "Please select date of birth."
let SUCCES = "Success."
let SELECT_IMAGE_SOURCE = "Please select image source."
let CAMERA_NOT_AVAILABELE = "Camera is not available."
let SUCCESS_SIGNUP = "Successfully signed up."

let BLANK_OLD_PASS = "Please enter old password."
let BLANK_NEW_PASS = "Please enter new password."
let MIN_NEW_PASSWORD = " New Password must be of atleast 8 characters."
let BLANK_CONFIRM_PASS = "Please enter confirm password."
let MIN_CONFIRM_PASS = "Confirm password must be of atleast 8 characters."
let BLANK_POSTCODE = "Please enter post code."
let MIN_POSTCODE = "Post code must be of 6 digits."
let BLANK_PINCODE = "Please enter pincode."
let MIN_PINCODE = "Pincode must be of 6 digits."

let BLANK_ADDRESS = "Please enter address."
let MAX_ADDRESS = "Address has maximum limit of atleast 120 characters"

let BLANK_COUNTRY = "Please enter country."
let VALID_COUNTRY = "Please enter valid country name."
let BLANK_SERVICE = "Please enter type of body massage."
let VALID_BODY_MASSAGE = "Please enter valid body massage type."
let BLANK_DATE_BOOK = "Please choose the date of booking."
let BLANK_TITLE = "Please enter title."
let BLANK_DESCRIPTION = "Please enter description."

let BLANK_TEAM = "Please enter team."
let BLANK_LOCATION = "Please enter location."
let MIN_TITLE = "Please enter atleast two character of title."
let MAX_TITLE = "Title has maximum limit of atleast 30 characters"
let BLANK_EMAILORMOBILE = "Please enter email address/mobile number."
func TRIM_SPACE(str: Any) -> Any {
    return (str as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}

func shadowOnView(view: Any) -> UIView  {
    
    (view as AnyObject).layer.masksToBounds = false
    
    (view as AnyObject).layer.shadowRadius = 1.0
    (view as AnyObject).layer.shadowColor = UIColor.black.cgColor
    (view as AnyObject).layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    (view as AnyObject).layer.shadowOpacity = 1
    
    return view as! UIView
}
