//
//  Constants.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation

class Constants {
    static let kBaseURL = "https://api.parse.com"
    
    struct URL {
        static let kGetAllProducts = kBaseURL +  "/1/classes/Product"
        static let kGetAllBrands = kBaseURL + "/1/classes/Brand"
        static let kGetAllUsers = kBaseURL + "/1/classes/User"
        static let kGetAllReviews = kBaseURL + "/1/classes/Review"
        static let kPostReview = kBaseURL + "/1/classes/Review"
    }
    struct Method {
        static let kPOSTMethod = "POST"
        static let kGETMethod  = "GET"
    }
    struct Config {
        static let kParseApplicationIdKey = "X-Parse-Application-Id"
        static let kParseApplicationIdValue = "MlR6vYpYvLRxfibxE5cg0e73jXojL6jWFqXU6F8L"
        static let kParseRestApiKey = "X-Parse-REST-API-Key"
        static let kParseRestApiValue = "7BTXVX1qUXKUCnsngL8LxhpEHKQ8KKd798kKpD9W"

        static let kHttpFieldContentTypeKey = "Content-Type"
        static let kHttpFieldContentTypeValue = "application/json"
        static let kHttpFieldAcceptKey = "Accept"
        static let kHttpFieldAcceptValue = "application/json"
        static let kHttpFieldNoCacheKey = "no-cache"
        static let kHttpFieldNoCacheValue = "Cache-Control"
        
        
        static let kDefaultErrorCode = 100
        static let kDefaultTimeOut = 30
        
        
        
    }
    

}


