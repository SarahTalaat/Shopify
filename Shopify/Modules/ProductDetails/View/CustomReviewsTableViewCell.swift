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
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
