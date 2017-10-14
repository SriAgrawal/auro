//
//  SearchInfo.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 16/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class SearchInfo: NSObject {
    var profileNameString  : String = "dfsf"
    var profileStatusString : String = "dfsdsf"
    var profileImage : String = ""

    class func getSeacrhListArray(responceArray : Array<Dictionary<String,String>>)->Array<SearchInfo>
    {
        var searchInfoArray =  Array<SearchInfo>()
        for searchItem in responceArray{
            let searchObj = SearchInfo()
            searchObj.profileNameString = searchItem["profileName"]!
            searchObj.profileStatusString = searchItem["profileStatus"]!
            searchObj.profileImage  = searchItem["profileImage"]!
            searchInfoArray.append(searchObj)
            
            
        }
    return searchInfoArray
    }
}
