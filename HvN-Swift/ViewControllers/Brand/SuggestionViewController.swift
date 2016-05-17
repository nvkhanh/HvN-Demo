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
    private var filterMode = false
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.title = "Brand List"
    }
    
    func initData() -> Void {
        self.showLoading()
        APIManager.sharedInstance().getBrands { (success, data, error) in
            self.hideLoading()
            if success == true {
                if let array = data as? [Brand] {
                    self.datasources = array
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
    func findBrandWithText(text : String){
        
        filterDatasources = datasources.filter({$0.brandName.lowercaseString.rangeOfString(text.lowercaseString) != nil})
        filterMode = text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 ?  true : false
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
