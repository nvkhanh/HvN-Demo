//
//  ReviewTableViewCell.swift
//  HvN-Swift
//
//  Created by khanh.nguyen on 11/05/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var ratingLabel : UILabel!
    @IBOutlet weak var commentLabel : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var containerView : UIView!

    var review : Review?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 3
        self.ratingView.userInteractionEnabled = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillUIWithReview(review : Review, users : [User]?) {
        self.review = review
        if let review = self.review {
            if let arrayUsers = users {
                review.updateUserName(arrayUsers)
                userNameLabel.text = String(format: "%@ - %@",review.userName!, Utils.convertDateToString(review.createdAt!))
            }
            ratingLabel.text = String(format: "Rating: %@",review.rating)
            commentLabel.text = review.comment
            ratingView.rating = Double(review.rating.doubleValue)
        }
        
    }
    
    class func getHeightWithComment(comment : NSString) -> CGFloat {
        let titleAttributes =  [NSFontAttributeName : UIFont.systemFontOfSize(14)]
        let maxWidth = Utils.getScreenSize().width - 16 - 16
        let size = CGSize(width: maxWidth, height: CGFloat.max)
        let commentTextSize = comment.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: titleAttributes, context: nil)
        
        return 25 + commentTextSize.height + 4 + 4 + 17 + 10
        
        
    }
    
}
