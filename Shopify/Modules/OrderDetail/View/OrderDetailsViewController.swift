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
    var viewModel = OrderDetailsViewModel()
    var currency = "USD"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = detailsCollectionViewLayout()
        self.title = "Order Details"
        
        viewModel.bindOrders = {
            self.updateCollection()
        }
        viewModel.bindCurrency = {
            self.updateCollection()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
                                                   heightDimension: .absolute(120))
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
            return viewModel.orders.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
            let item = viewModel.orders[indexPath.row]
            cell.numOfUnit.text = "Quantity:\(item.quantity)"
            cell.unitPrice.text = "\(item.price) \(viewModel.currency)"
            cell.productName.text = item.title
            var url = ""
                   viewModel.getProducts(productId: viewModel.orders[indexPath.row].productId ?? 0) { product in
                       url = product?.images.first?.src ?? ""
                       let imageURL = URL(string: url)
                       DispatchQueue.main.async {
                           cell.productImage.kf.setImage(with: imageURL)
                       }
                   }
      
            return cell
        }
        
    }

