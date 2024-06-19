//
//  CustomButton.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class CustomButton: UIButton {

    var isAddedToCart: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    func updateButtonAppearance() {
        if isAddedToCart {
            setTitle("Remove from Cart", for: .normal)
            setImage(UIImage(systemName: "cart.fill.badge.minus"), for: .normal)
            tintColor = .red
        } else {
            setTitle("Add to Cart", for: .normal)
            setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
            tintColor = .systemBlue
        }
    }
    
    func setupButton(){
        CustomButton.buttonRoundedCorner(button: self)
        CustomButton.buttonShadow(button: self)
    }
    
    static func buttonRoundedCorner(button: UIButton) {
        // Make sure the button's corners are rounded
        let cornerRadius: CGFloat = min(button.bounds.height, button.bounds.width) / 10
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
    }
    
    static func buttonShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
    }
    
    static func buttonImageColor(button: UIButton){
        // Set the image rendering mode to alwaysTemplate to use tintColor
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .red
    }
    
    static func setupButtonTitle(_ button: UIButton) {
        guard let titleLabel = button.titleLabel else { return }
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byClipping // Avoids truncating the text with dots
    }
    


}
