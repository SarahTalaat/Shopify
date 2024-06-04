//
//  AdsCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adsImage: UIImageView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           adsImage.layer.cornerRadius = 14
           adsImage.clipsToBounds = true
       }
}
