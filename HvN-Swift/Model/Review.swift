//
//  Review.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import ObjectMapper
class Review: BaseModel {
    var comment = ""
    var reviewId = ""
    var userId = ""
    var productId = ""
    var rating = NSNumber(int: 0)
    var updatedAt : NSDate?
    var userName = ""
    
    override func mapping(map: Map) {
        reviewId <- map["objectId"]
        comment <- map["comment"]
        updatedAt <- map["updatedAt"]
        productId <- map["productID.objectId"]
        rating <- map["rating"]
        userId <- map["userID.objectId"]
        
        
        updatedAt <- (map["updatedAt"],CustomDateTransform())
    }
    
    override class func objectFromDictionary(dict: NSDictionary) -> AnyObject {
        let object = Mapper<Review>().map(dict)
        return object!
        
    }
    override class func getListFromArrary(array : [AnyObject]) -> [AnyObject] {
        var result  = [Review]()
        for value in array {
            if let dict = value as? NSDictionary {
                result.append(Review.objectFromDictionary(dict) as! Review)
            }
        }
        result.sortInPlace({ (object1, object2) -> Bool in
            if object1.updatedAt == nil {
                return false
            }
            if object2.updatedAt == nil {
                return true
            }
            
            let compareResult = object1.updatedAt!.compare(object2.updatedAt!)
            if compareResult == NSComparisonResult.OrderedDescending {
                return true
            }
            else {
                return false
            }
        })
        
        
        return result
    }
    
    
    
}
