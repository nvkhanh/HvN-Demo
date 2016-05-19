//
//  ProductDetailViewController.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit

class ProductDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var productDescriptionLabel : UILabel!
    @IBOutlet weak var productBrandNameLabel : UILabel!
    @IBOutlet weak var totalReviewsLabel : UILabel!
    var product : Product?
    
    var datasources = [Review]()
    var users = [User]()
    var allReviews = [Review]()
    var reviews = [Review]()
    var localReview = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setUpUI()
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        if let product = self.product {
            productNameLabel.text = product.productName;
            productBrandNameLabel.text = product.brandName
            productDescriptionLabel.text = product.productDecription
            self.title =  product.productName
        }
        
    }
    
    func filterReviewDatasources() {
        for review in localReview {
            datasources.insert(review, atIndex: 0)
        }
        self.totalReviewsLabel.text = String(format: "Reviews (%d)", datasources.count)
    }
    
    func initData() {
        if let product = self.product {
            self.showLoading()
            APIManager.sharedInstance().getReviewOfProduct(product.productId) { (success, data, error) in
                self.hideLoading()
                if success == true {
                    if let reviews = data as? [Review] {
                        self.datasources = reviews
                        self.filterReviewDatasources()
                        self.tableView.reloadData()
                    }
                }else {
                    if let myError = error {
                        Utils.showAlertWithMessage(myError.localizedDescription)
                    }else {
                        Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                    }
                }
            }
        
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ReviewTableViewCell.getHeightWithComment(datasources[indexPath.row].comment)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell", forIndexPath: indexPath) as! ReviewTableViewCell
        cell.fillUIWithReview(datasources[indexPath.row], users: users)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasources.count
    }
    
    
}
