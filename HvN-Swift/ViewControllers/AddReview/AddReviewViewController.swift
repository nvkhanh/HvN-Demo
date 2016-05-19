//
//  AddReviewViewController.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 09/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import ZBarSDK
import MLPAutoCompleteTextField
import Cosmos



extension ZBarSymbolSet: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}

class AddReviewViewController: BaseViewController, ZBarReaderDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate, UITextFieldDelegate {
    
    var ZBarReader: ZBarReaderViewController?
    @IBOutlet weak var productIdTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var commentTextView : MLPAutoCompleteTextField!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var ratingLabel : UILabel!
    @IBOutlet weak var productNameLabel : UILabel!
    var product : Product?
    private var rating = CGFloat(1)
    var users = [User]()
    var products = [Product]()
    private var userTouchedOnBackButton = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = self.product {
            productIdTextField.text = product.productId
            productIdTextField.enabled = false
            self.productNameLabel.text = product.productName
        }
        
        self.initDataIfNeed()
        self.navigationItem.rightBarButtonItem = nil
        ratingLabel.text = "Rating: 1"
        self.title = "Add Review"
        ratingView.didTouchCosmos = didTouchCosmos
    }

    override func viewWillDisappear(animated : Bool){
        super.viewWillDisappear(animated)
        userTouchedOnBackButton = true
    }
    
    override func viewDidDisappear(animated : Bool){
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchedOnAddReViewButton() {
        self.view.endEditing(true)
        
        let message = self.validate()
        if message.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            
            let user = self.findMatchedUser(emailTextField.text!)
            if  user == nil {
                Utils.showAlertWithMessage(StringContents.MessageValidate.kUserNotFound)
            }else {
                self.showLoading()
                APIManager.sharedInstance().addReviews(commentTextView.text!, rating: NSNumber(float: Float(self.rating)), productId: self.productIdTextField.text!, userId: user!.userId) { (success : Bool, data : AnyObject?, error : NSError?)  -> () in
                    self.hideLoading()
                    if success  {
                        if let review = data as? Review {
                            self.cacheLocalReview(review)
                        }
                        self.handlerAddReviewSuccess(self.productIdTextField.text!)
                    }else {
                        Utils.showAlertWithMessage(error!.localizedDescription)
                    }
                }
            }
            
        }else {
            Utils.showAlertWithMessage(message)
        }
    }
    
    @IBAction func didTouchedOnScanBarCodeButton() {
        if (self.ZBarReader == nil) {
            self.ZBarReader = ZBarReaderViewController()
        }
        self.ZBarReader?.readerDelegate = self
        self.ZBarReader?.scanner.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_ENABLE, to: 1)
        self.ZBarReader?.readerView.zoom = 1.0
        self.ZBarReader?.modalInPopover = false
        self.ZBarReader?.showsZBarControls = false
        navigationController?.pushViewController(self.ZBarReader!, animated:true)
    }
    
    //MARK: -- TextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.productIdTextField && userTouchedOnBackButton == false{
            self.updateMatchedProduct(self.productIdTextField.text!)
        }
    }
    
    //MARK: -- AutoComplete TextField
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        var result = [String]()
        for value in users {
            if value.email.lowercaseString.rangeOfString(string.lowercaseString) != nil{
                result.append(value.email)
            }
        }
        return result
        
    }
    
    //MARK: -- Private Methods
    func initDataIfNeed() {
        self.showLoading()
        self.findSystemUsers { () in
            self.findSystemProducts({ () in
                self.hideLoading()
            })
        }
    }
    
    func cacheLocalReview(review : Review) {
        let navigationController = self.navigationController
        if let array : [UIViewController] = (navigationController?.viewControllers) {
            for value in array {
                if let viewController = value as? ProductsViewController {
                    viewController.localReview.append(review)
                }
            }
            for value in array {
                if let viewController = value as? ProductDetailViewController {
                    viewController.localReview.append(review)
                    viewController.filterReviewDatasources()
                    viewController.tableView.reloadData()
                }
            }
        }
    }
    
    func handlerAddReviewSuccess(productId : String) {
        let navigationController = self.navigationController
        var productDetailViewController : ProductDetailViewController?
        if let array : [UIViewController] = (navigationController?.viewControllers) {
            for value in array {
                if let viewController = value as? ProductDetailViewController {
                    if let product = viewController.product {
                        if product.productId == productId {
                            productDetailViewController = viewController
                        }
                    }
                }
            }
        }
        if let viewController =  productDetailViewController {
            self.navigationController?.popToViewController(viewController, animated: true)
        }else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func findSystemUsers(completion : CommonBlock) {
        if self.users.count == 0 {
            self.showLoading()
            APIManager.sharedInstance().getUsers({ (success, data, error) in
                self.hideLoading()
                if success == true {
                    if let array = data as? [User] {
                        self.users = array
                    }
                }else {
                    if let myError = error {
                        Utils.showAlertWithMessage(myError.localizedDescription)
                    }else {
                        Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                    }
                }
                completion()
            })
        }else {
            completion()
        }
    }
    
    func findSystemProducts(completion : CommonBlock) {
        if self.products.count == 0 {
            self.showLoading()
            APIManager.sharedInstance().getProducts { (success : Bool, data : AnyObject?, error : NSError?) -> () in
                self.hideLoading()
                if success == true {
                    if let value = data as? [Product] {
                        self.products = value
                    }
                }else {
                    if let myError = error {
                        Utils.showAlertWithMessage(myError.localizedDescription)
                    }else {
                        Utils.showAlertWithMessage(StringContents.ErrorMessage.kUnexpectedError)
                    }

                }
                completion()
            }
        }else {
            completion()
        }
    }
    
    func updateMatchedProduct(productId : String) {
        var found = false
        for value in products {
            if value.productId == productId {
                self.productNameLabel.text = value.productName
                found = true
                break
            }
        }
        if found == false {
            Utils.showAlertWithMessage(StringContents.MessageValidate.kProductNotFound)
            self.productNameLabel.text = ""
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let results: NSFastEnumeration = info[ZBarReaderControllerResults] as! NSFastEnumeration
        var symbolFound : ZBarSymbol?
        for symbol in results as! ZBarSymbolSet {
            symbolFound = symbol as? ZBarSymbol
            break
        }
        
        if let symbol = symbolFound {
            let resultString = NSString(string: symbol.data)
            self.productIdTextField.text = resultString as String;
            if productIdTextField.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                productIdTextField.enabled = false
                self.updateMatchedProduct(productIdTextField.text!)
            }
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func validate() -> String {
        var message = ""
        if self.productIdTextField.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            message = StringContents.MessageValidate.kMissingProductId
        }else if self.emailTextField.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            message = StringContents.MessageValidate.kInValidEmail
        }else if self.commentTextView.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            message = StringContents.MessageValidate.kMissingComment
        }
        
        return message
    }
    
    func findMatchedUser(email : String) -> User? {
        for value in users {
            if value.email.lowercaseString.rangeOfString(emailTextField.text!.lowercaseString) != nil{
                return value
            }
        }
        return nil
    }
    
    private func didTouchCosmos(rating: Double) {
        self.rating = CGFloat(rating)
        self.ratingLabel.text = String(format: "Rating: %.1f",rating)
    }
    
    
}
