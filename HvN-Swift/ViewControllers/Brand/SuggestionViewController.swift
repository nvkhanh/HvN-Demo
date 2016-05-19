//
//  SuggestionViewController.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 12/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit

typealias SuggestionBlock = (data : Brand?) -> ()

class SuggestionViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var datasources = [Brand]()
    private var filterDatasources = [Brand]()
    private var users = [User]()
    private var filterMode = false
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllBrands()
//        self.getAllRevies()
        self.setAllUser()
        self.title = "Brand List"
    }
    
    func getAllBrands() -> Void {
        self.showLoading()
        APIManager.sharedInstance().getBrands { (success, data, error) in
            self.hideLoading()
            if success == true {
                if let array = data as? [Brand] {
                    self.datasources = array
                    AppDataManager.sharedInstance().brands = array
                }
            }else {
                if let myError = error {
                    Utils.showAlertWithMessage(myError.localizedDescription)
                }else {
                    Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                }

            }
            self.tableView.reloadData()
        }
        
    }
    
    func getAllRevies() {
        APIManager.sharedInstance().getReviews { (success : Bool, data : AnyObject?, error : NSError?) -> () in
            if success == true {
                if let value = data as? [Review] {
                    AppDataManager.sharedInstance().reviewsOfSytem = value
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
    
    func setAllUser() {
        APIManager.sharedInstance().getUsers { (success : Bool, data :AnyObject?, error : NSError?) -> () in
            if success == true {
                if let allUsers = data as? [User] {
                    self.users = allUsers
                    AppDataManager.sharedInstance().users = allUsers
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
    
    func findBrandWithText(text : String){
        
        filterDatasources = datasources.filter({$0.brandName.lowercaseString.rangeOfString(text.lowercaseString) != nil})
        filterMode = text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 ?  true : false
        tableView.reloadData()
    }
    
    //MARK: -- TabbleView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = (filterMode ? filterDatasources[indexPath.row] : datasources[indexPath.row]).brandName
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterMode ? filterDatasources.count : datasources.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let brand = filterMode ? filterDatasources[indexPath.row] : datasources[indexPath.row]
        if let viewController = Utils.loadViewController("ProductsViewController", storyBoard: "Main") as? ProductsViewController {
            viewController.selectedBrand = brand
            viewController.brands = self.datasources
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    //MARK: -- SearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filterMode = true
        if let text = searchBar.text {
            findBrandWithText(text)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.findBrandWithText(searchText)
    }
    
    
}
