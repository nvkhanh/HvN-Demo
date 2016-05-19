//
//  ProductService.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class ProductService: BaseService {
    
    func getProducts(completion : CompletionBlock)  {
        self.callAPI(Constants.URL.kGetAllProducts, params: nil, method: Constants.Method.kGETMethod) { (success : Bool, responseObject : AnyObject?, error : NSError?) in
            if success {
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    if let array = jsonResult["results"] as? [AnyObject] {
                        let result = Product.getListFromArrary(array)
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
