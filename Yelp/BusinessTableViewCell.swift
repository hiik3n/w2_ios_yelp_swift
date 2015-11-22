//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Lam Do on 11/19/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!

    @IBOutlet weak var starsImage: UIImageView!
    
    var business: Business! {
        didSet {
            resNameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            typeLabel.text = business.categories
            profilePicImage.setImageWithURL(business.imageURL!)
            starsImage.setImageWithURL(business.ratingImageURL!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePicImage.layer.cornerRadius = 3
        profilePicImage.clipsToBounds = true
        
//        resNameLabel.preferredMaxLayoutWidth = resNameLabel.frame.size
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
