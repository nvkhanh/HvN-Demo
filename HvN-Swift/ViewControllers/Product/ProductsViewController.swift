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
    var brands = [Brand]()
    private var users = [User]()
    var selectedBrand : Brand?
    var localReview = [Review]()
    @IBOutlet weak var tableView : UITableView!
    private var totalPendingRequest = 1
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
        if let brand = selectedBrand {
            cell.reloadViewWithData(datasource[indexPath.row], brand: brand)
        }
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
        
        if let brand = selectedBrand {
            self.showLoading()
            APIManager.sharedInstance().getProductsByBrand(brand) { (success, data, error) in
                self.totalPendingRequest -= 1
                self.hideLoading()
                if success == true {
                    if let value = data as? [Product] {
                        self.datasource = value
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
    

    
    
}
