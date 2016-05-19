//
//  String.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 5/17/16.
//  Copyright © 2016 admin. All rights reserved.
//


import UIKit

class StringContents: NSObject {
    
    struct MessageValidate {
        static let kMissingProductId = "Missing product id"
        static let kInValidEmail = "The email isn't valid"
        static let kUserNotFound = "User doesn't exist"
        static let kProductNotFound = "No product found"
        static let kMissingComment = "Missing comment"
    }
    
    struct ErrorMessage {
        static let kUnexpectedError = "UnExpected Error..."
    }
}
