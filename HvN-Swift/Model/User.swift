//
//  User.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import ObjectMapper
class User: BaseModel {
    var userId = ""
    var userName = ""
    var isCustomer = true
    var email = ""
    
    override func mapping(map: Map) {
        userId <- map["objectId"]
        userName <- map["userName"]
        isCustomer <- map["IsCustomer"]
        email <- map["email"]
    }
    
    override class func objectFromDictionary(dict: NSDictionary) -> AnyObject {
        let object = Mapper<User>().map(dict)
        return object!
    }
    
    override class func getListFromArrary(array : [AnyObject]) -> [AnyObject] {
        var result  = [User]()
        for value in array {
            if let dict = value as? NSDictionary {
                result.append(User.objectFromDictionary(dict) as! User)
            }
        }
        return result
    }
    
}

