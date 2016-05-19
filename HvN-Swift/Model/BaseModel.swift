//
//  BaseModel.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import ObjectMapper
class BaseModel: Mappable {
    
    class func objectFromDictionary(dict : NSDictionary) -> AnyObject {
        preconditionFailure("This method must be overridden")
    }
    
    class func getListFromArrary(array : [AnyObject]) -> [AnyObject] {
        preconditionFailure("This method must be overridden")
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        preconditionFailure("This method must be overridden")
    }

}
class CustomDateTransform: DateTransform {
    
    internal override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timeInt = value as? Double {
            return Utils.convertStringToDate(String(format: "%d",timeInt))
        }
        
        if let timeStr = value as? String {
            return Utils.convertStringToDate(timeStr)
        }
        
        return nil
    }
    
    internal override func transformToJSON(value: NSDate?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
