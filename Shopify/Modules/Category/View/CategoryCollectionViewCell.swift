//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    @IBAction func addToFav(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 10
        categoryImage.clipsToBounds = true
    }
}
