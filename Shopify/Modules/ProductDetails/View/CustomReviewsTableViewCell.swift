//
//  CustomReviewsTableViewCell.swift
//  Shopify
//
//  Created by Sara Talat on 04/06/2024.
//

import UIKit

class CustomReviewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Setting the border color and width
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.borderWidth = 1.0
        
        // Setting the corner radius
        reviewTextView.layer.cornerRadius = 10.0
        reviewTextView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
