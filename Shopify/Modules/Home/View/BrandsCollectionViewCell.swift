//
//  BrandsCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        brandImage.layer.cornerRadius = 10
        brandImage.clipsToBounds = true
        brandImage.layer.borderWidth = 1
        brandImage.layer.borderColor = UIColor.lightGray.cgColor
    }
}
