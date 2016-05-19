//
//  ProductTableViewCell.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 10/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import Cosmos

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var brandLabel : UILabel!
    @IBOutlet weak var ratingLabel : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    var product : Product?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ratingView.userInteractionEnabled = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateRating() {
        if let rating = self.product?.rating {
            ratingLabel.text = String(format: "Rating: %.2f",rating.doubleValue)
            ratingView.rating = Double(rating.floatValue)
        } else {
            self.ratingLabel.text = ""
            self.ratingView.rating = Double(0)
            
        }
    }
    
    func reloadViewWithData(data : Product, brand: Brand) {
        self.product = data
        if let product = self.product {
            productNameLabel.text = product.productName
            product.brandName = brand.brandName
            
            brandLabel.text = product.brandName
            
            if let rating = product.rating {
                self.updateRating()
            }else {
                APIManager.sharedInstance().getReviewOfProduct(data.productId, completion: { (success, data, error) in
                    if let reviews = data as? [Review] {
                        product.updateRatingWithReviews(reviews)
                        self.updateRating()
                    }else {
                       self.updateRating()
                    }
                })
            }
        
        }
        
    }
    
}
