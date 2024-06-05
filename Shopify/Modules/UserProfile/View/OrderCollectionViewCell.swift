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
    private let bottomBorder = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBottomBorder()
    }
    
    private func setupBottomBorder() {
        bottomBorder.backgroundColor = .gray
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomBorder)

    }
}
