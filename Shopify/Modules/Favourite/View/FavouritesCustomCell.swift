//
//  FavouritesCustomCell.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class FavouritesCustomCell: UITableViewCell {

    @IBOutlet var productSize: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productType: UILabel!

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
