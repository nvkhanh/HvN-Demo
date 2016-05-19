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
        if let appDelegate  = UIApplication.sharedApplication().delegate as? AppDelegate {
            let viewController = appDelegate.window!.rootViewController!
            return viewController
        }
        return nil
    }
    
    func showLoading() {
        if let viewController = self.rootView() {
            let loadingNotification = MBProgressHUD.showHUDAddedTo(viewController.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Loading"
        }
    }
    
    func hideLoading() {
        if let viewController = self.rootView() {
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
    }
}