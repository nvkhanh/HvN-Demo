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
    
    class func sharedInstance() -> AppDataManager {
        struct Static {
            static let instance: AppDataManager = AppDataManager()
        }
        return Static.instance
    }
    func getAllUser(completion : CompletionBlock) {
        APIManager.sharedInstance().getUsers { (success : Bool, data :AnyObject?, error : NSError?) -> () in
            if success == true {
                if let allUsers = data as? [User] {
                    self.users = allUsers
                    AppDataManager.sharedInstance().users = allUsers
                    completion(success: true, data: allUsers, error: nil)
                }
            }else {
                completion(success: false, data: nil, error: error)
            }
        }
    }

}
