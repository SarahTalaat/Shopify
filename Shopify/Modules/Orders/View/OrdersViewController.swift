//
//  OrdersViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 02/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersCollectionView.collectionViewLayout = ordersCollectionViewLayout()

        // Do any additional setup after loading the view.
        
      
    }
    
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrdersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllOrdersCollectionViewCell", for: indexPath) as! AllOrdersCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.clipsToBounds = true
        
        cell.creationDate.text = "2024-6-22"
        cell.totalPrice.text = "200$"
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
                     let brandsViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                     navigationController?.pushViewController(brandsViewController, animated: true)
                  }
    
    }
