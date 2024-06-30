//
//  CartTableViewCell.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didTapPlusButton(on cell: CartTableViewCell)
    func didTapMinusButton(on cell: CartTableViewCell)
    func didTapDeleteButton(on cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    var productId: Int?
    weak var delegate: CartTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
           self.layer.borderWidth = 1.0
           self.layer.borderColor = UIColor.gray.cgColor
           self.layer.cornerRadius = 15.0
           self.layer.shadowColor = UIColor.gray.cgColor
           self.layer.shadowOffset = CGSize(width: 2, height: 2)
           self.layer.masksToBounds = false
           productimage.layer.cornerRadius = 15.0
           productimage.clipsToBounds = true
    }

    @IBAction func minus(_ sender: UIButton) {
        delegate?.didTapMinusButton(on: self)
        print("minus")
    }
    @IBOutlet weak var productPrice: UILabel!
    
    @IBAction func plus(_ sender: UIButton) {
        delegate?.didTapPlusButton(on: self)
        print("plus")
    }
    
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        delegate?.didTapDeleteButton(on: self)
        //self.shoppingCartDeletionDeletegate?.didDeleteProduct(id: productId ?? 0,cartCell:  self)
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
