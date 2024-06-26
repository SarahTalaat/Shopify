//
//  addressTableViewCell.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class addressTableViewCell: UITableViewCell {
    
    var defaultButtonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
    }
    
    
    
    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var addressDetails: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var defaultButton: UIButton!
    
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func configure(with address: Address, isDefault: Bool?) {
        userName.text = address.first_name
        addressDetails.text = "\(address.address1), \(address.city), \(address.country)"
        defaultButton.isHidden = !address.default! // Show defaultButton if address is default
      //  backgroundColor = address.default! ? UIColor.systemRed.withAlphaComponent(0.2) : UIColor.clear
    }
}
