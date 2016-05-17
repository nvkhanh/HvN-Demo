//
//  UserService.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class UserService: BaseService {
    func getUsers(completion : CompletionBlock)  {
        
        self.callAPI(Constants.URL.kGetAllUsers, params: nil, method: Constants.Method.kGETMethod) { (success : Bool, responseObject : AnyObject?, error : NSError?) in
            if success {
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    if let array = jsonResult["results"] as? [AnyObject] {
                        let result = User.getListFromArrary(array)
                        completion(success: true, data: result, error: nil)
                    }else {
                        completion(success: false, data: nil, error: NSError(domain: "", code: Constants.Config.kDefaultErrorCode, userInfo: nil))
                    }
                    
                }else {
                    completion(success: false, data: nil, error: NSError(domain: "", code: Constants.Config.kDefaultErrorCode, userInfo: nil))
                }
            }else {
                completion(success: false , data: nil, error: error)
            }
        }
        
    }

}
