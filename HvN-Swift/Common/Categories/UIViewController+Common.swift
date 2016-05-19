//
//  UIViewController+Common.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 15/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//
import UIKit
import Foundation
import MBProgressHUD


extension UIViewController {
    
    func rootView() -> UIViewController? {
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController!
        return viewController
        
    }
    
    func showLoading() {
        let viewController = self.rootView()
        if viewController != nil {
            let loadingNotification = MBProgressHUD.showHUDAddedTo(viewController!.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Loading"
        }
    }
    
    func hideLoading() {
        let viewController = self.rootView()
        if viewController != nil {
            MBProgressHUD.hideAllHUDsForView(viewController!.view, animated: true)
        }
    }
}