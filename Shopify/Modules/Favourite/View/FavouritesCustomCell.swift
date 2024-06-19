//
//  FavouritesCustomCell.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class FavouritesCustomCell: UITableViewCell {

    
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var vendorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8

    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    


    
    
}
