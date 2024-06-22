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
    
    @IBAction func addToFav(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didTapFavoriteButton(index: indexPath.row)
            print("fff addToFavButton index: \(indexPath.row)")
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
    
    @objc private func toggleFavorite() {
        guard let productId = productId else { return }
        delegate?.productsCollectionViewCellDidToggleFavorite(at: indexPath?.row ?? 0)
    }
    
//    private func updateFavoriteUI(isFavorite: Bool) {
//        let imageName = isFavorite ? "heart.fill" : "heart"
//        favBtn.setImage(UIImage(systemName: imageName), for: .normal)
//    }
    func updateFavoriteUI(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)

        if isFavorite {
            favBtn.tintColor = .red
        } else {
            let config = UIImage.SymbolConfiguration(weight: .light)
            let outlinedImage = image?.withConfiguration(config)
            favBtn.setImage(outlinedImage, for: .normal)
            favBtn.tintColor = .red
        }

        favBtn.setImage(image, for: .normal)
    }
    
    

}
