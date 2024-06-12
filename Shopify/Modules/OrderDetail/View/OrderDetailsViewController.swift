//
//  OrderDetailsViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 02/06/2024.
//

import UIKit
import Kingfisher

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = OrderDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = detailsCollectionViewLayout()
        self.title = "Order Details"
        
        viewModel.bindProducts = {
            self.updateCollection()
        }
    }
    
    func updateCollection(){
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
 

    
    
    
    
    // MARK: - Collection View Layout Drawing
    
    func detailsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
    }
}

// MARK: - UICollectionView Methods

    extension OrderDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.products.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
            let item = viewModel.products[indexPath.row]
            cell.numOfUnit.text = "Unit:1"
            cell.orderBrand.text = item.vendor
            cell.unitColor.text = "Color:Black"
            cell.unitPrice.text = "\(item.variants.first?.price)$"
            cell.unitSize.text = "Size:M"
            cell.productName.text = item.title
            
            if let imageUrlString = item.images.first?.src, let imageUrl = URL(string: imageUrlString) {
                cell.orderImage.kf.setImage(with: imageUrl)
            }
            return cell
        }
        
    }

