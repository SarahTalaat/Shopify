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
        // Initialization code
    }

    @IBOutlet weak var productPrice: UILabel!
    @IBAction func plus(_ sender: UIButton) {
    }
    @IBAction func minus(_ sender: UIButton) {
    }
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
