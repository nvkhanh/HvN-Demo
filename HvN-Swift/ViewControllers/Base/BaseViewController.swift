//
//  BaseViewController.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.createRightBarButtonWithTitle("Add Review")
    }

    func createRightBarButtonWithTitle(title : String){
        let barButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(didTouchedOnRightBarButton))
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    func didTouchedOnRightBarButton() {
        if let viewController = Utils.loadViewController("AddReviewViewController", storyBoard: "Main") as? AddReviewViewController {
            if let productDetailViewController = self as? ProductDetailViewController {
                viewController.product = productDetailViewController.product
                viewController.users = productDetailViewController.users
            }
            if let productViewController = self as? ProductsViewController {
                viewController.products = productViewController.allProducts
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
