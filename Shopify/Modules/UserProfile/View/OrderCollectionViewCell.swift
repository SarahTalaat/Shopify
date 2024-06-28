//
//  OrderCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 02/06/2024.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var orderPrice: UILabel!
    
    @IBOutlet weak var creationDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
