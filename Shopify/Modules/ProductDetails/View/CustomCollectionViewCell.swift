//
//  CustomCollectionViewCell.swift
//  Shopify
//
//  Created by Sara Talat on 03/06/2024.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet var productImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellAppearance()
        
    }
    
    private func configureCellAppearance() {
        // Set the corner radius for the cell
        self.layer.cornerRadius = 10
        
        // Set border properties
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        // Apply corner radius to the image
        productImage.layer.cornerRadius = 8
        productImage.clipsToBounds = true
        
        // Set fixed size for the productImage
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
   
    }
    

    
}
