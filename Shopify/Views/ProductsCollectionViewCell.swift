//
//  ProductsCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
   
    var productId: String?
    weak var delegate: ProductsCollectionViewCellDelegate?
    var indexPath: IndexPath?
    
    var viewModel: ProductViewModel = ProductViewModel()
    
    @IBAction func addToFav(_ sender: UIButton) {
        if viewModel.isGuest() == true {
            if let indexPath = indexPath {
                delegate?.didTapFavoriteButton(index: indexPath.row)
                print("fff addToFavButton index: \(indexPath.row)")
            }
        }

    }
    
    
 

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favBtn.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favBtn.layer.shadowColor = UIColor.gray.cgColor
        favBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        favBtn.layer.shadowOpacity = 0.5
        favBtn.layer.shadowRadius = 4
        
        
        productImage.layer.cornerRadius = 10
        productImage.clipsToBounds = true
        productImage.layer.borderWidth = 1
        productImage.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configure(with productId: String, isFavorite: Bool, index: Int) {
        self.productId = productId
        updateFavoriteUI(isFavorite: isFavorite)
    }

    func updateFavoriteUI(isFavorite: Bool) {
        if viewModel.isGuest() == true {
            let imageName = isFavorite ? "heart.fill" : "heart"
            let image = UIImage(systemName: imageName)
            favBtn.tintColor = isFavorite ? .red : .lightGray
            favBtn.setImage(image, for: .normal)
        }
    }
    
    @objc private func toggleFavorite() {
        guard let productId = productId else { return }
        delegate?.productsCollectionViewCellDidToggleFavorite(at: indexPath?.row ?? 0)
    }
    
//    private func updateFavoriteUI(isFavorite: Bool) {
//        let imageName = isFavorite ? "heart.fill" : "heart"
//        favBtn.setImage(UIImage(systemName: imageName), for: .normal)
//    }


}
