//
//  BaseService.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import AFNetworking
class BaseService: NSObject {
    
    func callAPI(url: String, params : NSDictionary?, method : String, completion : CompletionBlock) -> () {
        let url = NSURL(string: url)
        let currentTime = NSTimeInterval(Constants.Config.kDefaultTimeOut)
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: currentTime)
        request.HTTPMethod = method
        
        if params != nil && method == Constants.Method.kPOSTMethod {
            let jsonData:NSData = try! NSJSONSerialization.dataWithJSONObject(params!, options: .PrettyPrinted)
            request.HTTPBody = jsonData
        }
        request.addValue(Constants.Config.kHttpFieldContentTypeValue, forHTTPHeaderField: Constants.Config.kHttpFieldContentTypeKey)
        request.addValue(Constants.Config.kHttpFieldAcceptValue, forHTTPHeaderField:Constants.Config.kHttpFieldAcceptKey)
        request.addValue(Constants.Config.kParseApplicationIdValue, forHTTPHeaderField: Constants.Config.kParseApplicationIdKey)
        request.addValue(Constants.Config.kParseRestApiValue, forHTTPHeaderField: Constants.Config.kParseRestApiKey)
        
        
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFJSONResponseSerializer()
        operation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            operation.cancel()
            completion(success: true , data: responseObject, error: nil)
            
            },
                                                
                                                failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                                                    operation.cancel()
                                                    completion(success: false , data: nil, error: error)
                                                    
        })
        
        operation.start()
    }
}
