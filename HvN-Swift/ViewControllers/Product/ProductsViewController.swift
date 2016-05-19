//
//  ProductsViewController.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit


class ProductsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allProducts = [Product]()
    private var datasource = [Product]()
    private var reviews = [Review]()
    private var brands = [Brand]()
    private var users = [User]()
    var selectedBrand : Brand?
    var localReview = [Review]()
    @IBOutlet weak var tableView : UITableView!
    private var totalPendingRequest = 4
    private var filterMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initData()
        self.setUpUI()
    }
    
    //MARK: -- TableView Method
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductTableViewCell", forIndexPath: indexPath) as! ProductTableViewCell
        cell.reloadViewWithData(datasource[indexPath.row], reviews: reviews, brands: brands)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let productDetailViewController = Utils.loadViewController("ProductDetailViewController", storyBoard: "Main") as? ProductDetailViewController {
            productDetailViewController.product = datasource[indexPath.row]
            productDetailViewController.allReviews = self.reviews
            productDetailViewController.users = self.users
            self.navigationController?.pushViewController(productDetailViewController, animated: true)
        }
    }
    
    //MARK: -- Private Method
    func setUpUI() {
        self.title = "Product List"
        
    }
    
    func initData() {
        self.showLoading()
        
        APIManager.sharedInstance().getProducts { (success : Bool, data : AnyObject?, error : NSError?) -> () in
            self.totalPendingRequest -= 1
            if success == true {
                if let value = data as? [Product] {
                    self.allProducts = value
                    self.filterDatasourceBySelectedBrand()
                }
            }else {
                if let myError = error {
                    Utils.showAlertWithMessage(myError.localizedDescription)
                }else {
                    Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                }
                
            }
            self.reloadDataIfNeed()
        }
        
        APIManager.sharedInstance().getBrands { (success : Bool, data : AnyObject?, error : NSError?) -> () in
            self.totalPendingRequest -= 1
            if success == true {
                if let value = data as? [Brand] {
                    self.brands = value
                }
            }else {
                if let myError = error {
                    Utils.showAlertWithMessage(myError.localizedDescription)
                }else {
                    Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                }

            }
            self.reloadDataIfNeed()
        }
        
        APIManager.sharedInstance().getReviews { (success : Bool, data : AnyObject?, error : NSError?) -> () in
            self.totalPendingRequest -= 1
            if success == true {
                if let value = data as? [Review] {
                    self.reviews = value
                }
            }else {
                if let myError = error {
                    Utils.showAlertWithMessage(myError.localizedDescription)
                }else {
                    Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                }

            }
            self.reloadDataIfNeed()
        }
        
        APIManager.sharedInstance().getUsers { (success : Bool, data :AnyObject?, error : NSError?) -> () in
            if success == true {
                if let allUsers = data as? [User] {
                    self.users = allUsers
                }
            }else {
                if let myError = error {
                    Utils.showAlertWithMessage(myError.localizedDescription)
                }else {
                    Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                }
            }
            self.totalPendingRequest -= 1
            self.reloadDataIfNeed()
        }
    }
    
    func reloadDataIfNeed() {
        if totalPendingRequest == 0 {
            tableView.reloadData()
            self.hideLoading()
        }
    }
    
    func filterDatasourceBySelectedBrand() {
        if let brand = selectedBrand {
            self.datasource = allProducts.filter({$0.brandId == brand.brandId})
        }
        
    }
}
