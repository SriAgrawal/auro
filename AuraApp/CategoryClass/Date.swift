//
//  Date.swift
//  AuraApp
//
//  Created by Krati Agarwal on 27/09/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import Foundation

import UIKit

extension Date {
    
    func UTCDateFormat() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        
        return formatter.string(from: self)
    }
    
    func convertDateToTimeStamp() -> TimeInterval {
    
        let seconds = self.timeIntervalSince1970
        let milliseconds = seconds*1000
    
        return milliseconds;
    }
    
    func getDateString() -> String {
    
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.system
        formatter.dateFormat = "MMM d, yyyy"
    
        return formatter.string(from: self)
    }
    
    func getDateTimeString() -> String {
    
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.system
        formatter.dateFormat = "MMM d, yyyy, hh:mm a"
        
        return formatter.string(from: self)
    }
    
    func getTimeDateString() ->String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.system
        formatter.dateFormat = "hh:mm a, MMM d, yyyy"
        
        return formatter.string(from: self)
    }
    
    func getDateStringWithFormat(format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.system
        formatter.dateFormat = format
        
        return formatter.string(from: self)
       }
    
    func getTimeString() -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.system
        formatter.dateFormat = "hh:mm a"
        
        return formatter.string(from: self)
        
    }
    
}
