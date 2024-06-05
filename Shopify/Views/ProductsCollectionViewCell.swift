//
//  ProductsCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    
    @IBAction func addToFav(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favBtn.layer.shadowColor = UIColor.gray.cgColor
        favBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        favBtn.layer.shadowOpacity = 0.5
        favBtn.layer.shadowRadius = 4
    }

}
