//
//  CustomButton.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class CustomButton: UIButton {



    static func buttonRoundedCorner(button:UIButton){
        // Make sure the button's corners are rounded
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }
    
    static func buttonShadow(button: UIButton){
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
    
    static func setupButton(_ button: UIButton) {
        guard let titleLabel = button.titleLabel else { return }
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byClipping // Avoids truncating the text with dots
    }
    


}
