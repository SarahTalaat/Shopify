//
//  OrderDetailsCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 02/06/2024.
//

import UIKit

class OrderDetailsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var numOfUnit: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    private let bottomBorder = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
     
        setupBottomBorder()
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
