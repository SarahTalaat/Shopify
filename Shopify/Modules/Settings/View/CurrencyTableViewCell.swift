//
//  CurrencyTableViewCell.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 04/06/2024.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var currency: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 1.0
               contentView.layer.borderColor = UIColor.lightGray.cgColor
               

               contentView.layer.shadowColor = UIColor.black.cgColor
               contentView.layer.shadowOpacity = 0.5
               contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
               contentView.layer.shadowRadius = 2.0
               
         
               contentView.layer.masksToBounds = false
               
      
               contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
