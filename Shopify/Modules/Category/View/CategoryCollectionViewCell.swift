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
    
    private let bottomBorder = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 16
        categoryImage.clipsToBounds = true
        setupImageViewShadow()
        setupBottomBorder()
    }
    
    func setupImageViewShadow() {
        categoryImage.layer.shadowColor = UIColor.black.cgColor
        categoryImage.layer.shadowOpacity = 0.5
        categoryImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        categoryImage.layer.shadowRadius = 4
        categoryImage.layer.masksToBounds = false
    }
    
     func setupBottomBorder() {
           bottomBorder.backgroundColor = UIColor.lightGray
           bottomBorder.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(bottomBorder)
           
           NSLayoutConstraint.activate([
               bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
               bottomBorder.heightAnchor.constraint(equalToConstant: 1)
           ])
       }
}
