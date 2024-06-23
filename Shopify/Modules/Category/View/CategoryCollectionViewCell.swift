//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    var productId: String?
    var delegate: ProductsTableViewCellDelegate?
    var indexPath: IndexPath?
    
    @IBAction func addToFav(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didTapFavoriteButton(index: indexPath.row)
            print("kjkj addToFavButton index: \(indexPath.row)")
        }
    }
    
    private let bottomBorder = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        favBtn.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        categoryImage.layer.cornerRadius = 16
        categoryImage.clipsToBounds = true
        setupImageViewShadow()
        setupBottomBorder()
    }
    
    func setupImageViewShadow() {
        categoryImage.layer.shadowColor = UIColor.black.cgColor
        categoryImage.layer.shadowOpacity = 0.5
        categoryImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        categoryImage.layer.shadowRadius = 4
        categoryImage.layer.masksToBounds = false
    }
    
     func setupBottomBorder() {
           bottomBorder.backgroundColor = UIColor.lightGray
           bottomBorder.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(bottomBorder)
           
           NSLayoutConstraint.activate([
               bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
               bottomBorder.heightAnchor.constraint(equalToConstant: 1)
           ])
       }
        
    func configure(with productId: String, isFavorite: Bool, index: Int) {
        self.productId = productId
        updateFavoriteUI(isFavorite: isFavorite)
    }

    func updateFavoriteUI(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favBtn.tintColor = isFavorite ? .red : .lightGray
        favBtn.setImage(image, for: .normal)
    }
    
    @objc private func toggleFavorite() {
        guard let productId = productId else { return }
        delegate?.productsTableViewCellDidToggleFavorite(at: indexPath?.row ?? 0)
    }

}
