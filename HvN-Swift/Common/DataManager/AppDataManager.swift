//
//  AppDataManager.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/19/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class AppDataManager: NSObject {
    
    var users  : [User]?
    var brands : [Brand]?
    var reviewsOfSytem : [Review]?
    
    class func sharedInstance() -> AppDataManager {
        struct Static {
            static let instance: AppDataManager = AppDataManager()
        }
        return Static.instance
    }
    

}
