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
    func reloadViewWithData(data : Product, reviews: [Review], brands: [Brand]) {
        self.product = data
        if let product = self.product {
            productNameLabel.text = product.productName
            product.updateBrandName(brands)
            
            brandLabel.text = product.brandName
            
            product.updateRatingWithReviews(reviews)
            
            if let rating = product.rating {
                ratingLabel.text = String(format: "Rating: %.2f",rating.doubleValue)
                ratingView.rating = Double(rating.floatValue)
            }else {
                ratingLabel.text = ""
                ratingView.rating = Double(0)
            }
        
        }
    }
    
}
