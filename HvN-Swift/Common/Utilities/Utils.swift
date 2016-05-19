//
//  Utils.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 10/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func  convertStringToDate(string : String) -> NSDate? {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormat.dateFromString(string as String) {
            return date;
        }else {
            return nil
        }
    }
    
    class func convertDateToString(date : NSDate) -> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd/MM/YYYY"
        return dateFormat.stringFromDate(date)
    }
    
    class func loadViewController(name : String, storyBoard : String) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyBoard, bundle: nil)
        let viewController = storyBoard.instantiateViewControllerWithIdentifier(name)
        return viewController
    }
    
    class func getScreenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds
        return screenSize.size
    }
    
    class func showAlertWithMessage(message: String)  {
        let alert = UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    class func convertDictionaryToString(dict : NSDictionary) -> String {
        var result : NSString = ""
        do {
            let arrJson = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
            let string = NSString(data: arrJson, encoding: NSUTF8StringEncoding)
            result = string! as NSString
        }catch let error as NSError{
            print(error.description)
        }
        return result as String
    }
}
