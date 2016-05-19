//
//  Product.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import ObjectMapper
class Product: BaseModel {
    var productId = ""
    var productName = ""
    var productDecription = ""
    var price = ""
    var dateCreate = NSDate()
    var avaibilityStatus = ""
    var brandId = ""
    
    var brandName : String?
    var rating : NSNumber?
    
    
    override func mapping(map: Map) {
        productId <- map["objectId"]
        productDecription <- map["description"]
        productName <- map["productName"]
        avaibilityStatus <- map["availabilityStatus"]
        brandId <- map["brandID.objectId"]
        dateCreate <- (map["dateCreated.iso"],CustomDateTransform())
    }
    
    override class func objectFromDictionary(dict: NSDictionary) -> AnyObject {
        let object = Mapper<Product>().map(dict)
        return object!
        
    }
    
    override class func getListFromArrary(array : [AnyObject]) -> [AnyObject] {
        var result  = [Product]()
        for value in array {
            if let dict = value as? NSDictionary {
                result.append(Product.objectFromDictionary(dict) as! Product)
            }
        }
        result.sortInPlace({ (object1, object2) -> Bool in
            let compareResult = object1.dateCreate.compare(object2.dateCreate)
            if compareResult == NSComparisonResult.OrderedDescending {
                return true
            }
            else if compareResult == NSComparisonResult.OrderedSame {
                return object1.productName < object2.productName
            }
            else {
                return false
            }
        })
        
        return result
    }
    
    func updateBrandName(brands : [Brand]) {
        if self.brandName == nil {
            
            if let index = brands.indexOf({$0.brandId == self.brandId}){
                self.brandName = brands[index].brandName
            }
            
        }
    }
    
    func updateRatingWithReviews(reviews : [Review]) {
        if self.rating == nil {
            var count = Float(0)
            var total = Float(0)
            for value in reviews {
                if value.productId == self.productId {
                    count += 1
                    total = Float(total) +  value.rating.floatValue
                }
            }
            if count  != 0 {
                self.rating = NSNumber(float: total / count)
            }else {
                self.rating = nil
            }
        }
    }
}
