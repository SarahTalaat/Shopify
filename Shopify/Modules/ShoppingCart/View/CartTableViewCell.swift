//
//  CartTableViewCell.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit


class CartTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
           self.layer.borderWidth = 1.0
           self.layer.borderColor = UIColor.gray.cgColor
           self.layer.cornerRadius = 15.0
           self.layer.shadowColor = UIColor.gray.cgColor
           self.layer.shadowOffset = CGSize(width: 2, height: 2)
         
           self.layer.shadowOpacity = 0.5
           self.layer.masksToBounds = false
           productimage.layer.cornerRadius = 15.0
           productimage.clipsToBounds = true
    }

    @IBAction func minus(_ sender: UIButton) {
  
        print("minus")
    }
    @IBOutlet weak var productPrice: UILabel!
    
    @IBAction func plus(_ sender: UIButton) {

        print("plus")
    }
    
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
