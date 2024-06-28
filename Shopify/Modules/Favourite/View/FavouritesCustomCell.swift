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
    
    private let bottomBorder = UIView()
    
    @IBOutlet weak var vendorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8

    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        favImage.layer.cornerRadius = 16
        favImage.clipsToBounds = true
        setupImageViewShadow()
        setupBottomBorder()
    }
    


    func setupImageViewShadow() {
        favImage.layer.shadowColor = UIColor.black.cgColor
        favImage.layer.shadowOpacity = 0.5
        favImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        favImage.layer.shadowRadius = 4
        favImage.layer.masksToBounds = false
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
