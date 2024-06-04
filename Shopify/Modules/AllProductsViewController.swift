//
//  AllProductsViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 04/06/2024.
//

import UIKit

class AllProductsViewController: UIViewController {

    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func searchTextFeild(_ sender: UITextField) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        collectionView.collectionViewLayout = brandsCollectionViewLayout()
    }
    
    
    func brandsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                         heightDimension: .fractionalHeight(1.0))
                   let item = NSCollectionLayoutItem(layoutSize: itemSize)
                   item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                   let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(260))
                   let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                   
                   let section = NSCollectionLayoutSection(group: group)
                   section.interGroupSpacing = 10
                   section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                   
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
extension AllProductsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.brandLabel.text = "Zara"
        cell.priceLabel.text = "9$"
        cell.productNameLabel.text = "Black Dress"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        navigationController?.pushViewController(brandsViewController, animated: true)
      }
    
    
    
    
}
