//
//  BusinessCell.swift
//  Yelp
//
//  Created by Hoan Le on 9/3/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var distanceLable: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewCountLable: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business!{
        didSet{
            nameLable.text = business.name
            nameLable.numberOfLines = 0
            thumbImageView.setImageWithURL(business.imageURL)
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewCountLable.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL)
            distanceLable.text = business.distance
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        nameLable.preferredMaxLayoutWidth = nameLable.frame.size.width 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLable.preferredMaxLayoutWidth = nameLable.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
