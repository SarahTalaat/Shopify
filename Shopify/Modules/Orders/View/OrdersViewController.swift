//
//  OrdersViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 02/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersCollectionView: UICollectionView!
    let ordersViewModel = OrdersViewModel()
    var detailsModel = OrderDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        ordersCollectionView.collectionViewLayout = ordersCollectionViewLayout()
        
        ordersViewModel.bindAllOrders = {
            self.updateCollection()
        }
    }
    
    func updateCollection(){
            DispatchQueue.main.async { [weak self] in
                self?.ordersCollectionView.reloadData()
            }
        }
 
    
    // MARK: - Collection View Layout Drawing

    func ordersCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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

    extension OrdersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return min(2, ordersViewModel.orders.count)

        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllOrdersCollectionViewCell", for: indexPath) as! AllOrdersCollectionViewCell
            
                   let item = ordersViewModel.orders[indexPath.row]
                   cell.layer.cornerRadius = 10
                   cell.layer.borderWidth = 1.0
                   cell.clipsToBounds = true
                   
                   let date = item.created_at
                   let datePart = date?.split(separator: "T").first.map(String.init)
                   cell.creationDate.text = "Created At: \(datePart ?? " ")"
            
                    if let totalPrice = item.total_price {
                        cell.totalPrice.text = "\(totalPrice)$"
                    } else {
                        cell.totalPrice.text = "0.00$"
                    }

                   return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
            detailsModel.id = ordersViewModel.orders[indexPath.row].id ?? 0
             let storyboard = UIStoryboard(name: "Second", bundle: nil)
             let orderDetailsViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            orderDetailsViewController.viewModel = detailsModel

             navigationController?.pushViewController(orderDetailsViewController, animated: true)
            }
        
}
