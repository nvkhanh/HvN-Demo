//
//  DataManager.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import AFNetworking


typealias CompletionBlock = ( success : Bool, data : AnyObject?, error : NSError?) -> ()
typealias CommonBlock = () -> ()
class APIManager: NSObject {
    
    
    private var brandService = BrandService()
    private var userService = UserService()
    private var productService = ProductService()
    private var reviewService = ReviewService()
    
    class func sharedInstance() -> APIManager {
        struct Static {
            static let instance: APIManager = APIManager()
        }
        return Static.instance
    }
    
    func getBrands(completion : CompletionBlock) {
        APIManager.sharedInstance().brandService.getBrands(completion)
    }
    func getUsers(completion : CompletionBlock)  {
        APIManager.sharedInstance().userService.getUsers(completion)
    }
    func getReviews(completion : CompletionBlock)  {
        APIManager.sharedInstance().reviewService.getReviews(completion)
    }
    func getProducts(completion : CompletionBlock)  {
        APIManager.sharedInstance().productService.getProducts(completion)
    }
    func addReviews(comment: String, rating : NSNumber,  productId : String, userId : String, completion : CompletionBlock)  {
        APIManager.sharedInstance().reviewService.addReviews(comment, rating: rating, productId: productId, userId: userId, completion: completion)
    }
    func getReviewOfProduct(productId : String, completion : CompletionBlock) {
        APIManager.sharedInstance().reviewService.getReviewOfProduct(productId, completion: completion)
    }

}
