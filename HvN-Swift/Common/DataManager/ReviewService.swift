//
//  ReviewService.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/17/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class ReviewService: BaseService {
    
    func getReviews(completion : CompletionBlock)  {
        self.callAPI(Constants.URL.kGetAllReviews, params: nil, method: Constants.Method.kGETMethod) { (success : Bool, responseObject : AnyObject?, error : NSError?) in
            if success {
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    if let array = jsonResult["results"] as? [AnyObject] {
                        let result = Review.getListFromArrary(array)
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
    
    func addReviews(comment: String, rating : NSNumber,  productId : String, userId : String, completion : CompletionBlock)  {
        var params = NSMutableDictionary()
        let productDict = ["__type" : "Pointer", "className" : "Product", "objectId" : productId]
        let userDict = ["__type" : "Pointer", "className" : "User", "objectId" : userId]
        params = ["comment" : comment, "productID" : productDict, "userID" : userDict, "rating" : rating]
        
        self.callAPI(Constants.URL.kPostReview, params: params, method: Constants.Method.kPOSTMethod) { (success : Bool, responseObject : AnyObject?, error : NSError?) in
            if success == true {
                if let data = responseObject as? NSDictionary {
                    let dictReview = NSMutableDictionary(dictionary: data)
                    dictReview.setValue(productDict, forKey: "productID")
                    dictReview.setValue(rating, forKey: "rating")
                    dictReview.setValue(userDict, forKey: "userID")
                    dictReview.setValue(comment, forKey: "comment")
                    completion(success: true , data: Review.objectFromDictionary(dictReview), error: nil)
                }else {
                    completion(success: false , data: nil, error: NSError(domain: "", code: Constants.Config.kDefaultErrorCode, userInfo: nil))
                }
            }else {
                completion(success: false , data: nil, error: error)
            }
        }
        
    }
    
    func getReviewOfProduct(productId : String, completion : CompletionBlock) {
        let dict = ["productID" : ["$inQuery" :["where" : ["objectId" :productId],"className": "Product"]]];
        var queryUrl = Constants.URL.kPostReview
        queryUrl += "?where="
        queryUrl += Utils.convertDictionaryToString(dict)
        
        if let encodedURL = queryUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            
            self.callAPI(encodedURL, params: nil, method: Constants.Method.kGETMethod) { (success : Bool, responseObject : AnyObject?, error : NSError?) in
                if success == true {
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        if let array = jsonResult["results"] as? [AnyObject] {
                            let result = Review.getListFromArrary(array)
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
            
        }else {
            completion(success: false, data: nil, error: NSError(domain: "", code: Constants.Config.kDefaultErrorCode, userInfo: nil))
        }
    }
    


}
