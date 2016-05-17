//
//  Brand.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import ObjectMapper
class Brand: BaseModel {
    var brandId  = ""
    var brandName = ""
    var brandDescription = ""
    
    override func mapping(map: Map) {
        brandDescription <- map["description"]
        brandId <- map["objectId"]
        brandName <- map["name"]
        
    }
    override class func objectFromDictionary(dict: NSDictionary) -> AnyObject {
        let object = Mapper<Brand>().map(dict)
        return object!
        
    }
    override class func getListFromArrary(array : [AnyObject]) -> [AnyObject] {
        var result  = [Brand]()
        for value in array {
            if let dict = value as? NSDictionary {
                result.append(Brand.objectFromDictionary(dict) as! Brand)
            }
        }
        return result
    }
}
