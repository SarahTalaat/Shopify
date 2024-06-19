//
//  AllProductsViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 04/06/2024.
//

import UIKit
import Kingfisher

class AllProductsViewController: UIViewController {

    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    
    let viewModel = AllProductsViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Products"
        let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        collectionView.collectionViewLayout = brandsCollectionViewLayout()
        
        viewModel.bindAllProducts = {
            self.updateCollection()
        }
    }
    
         func updateCollection(){
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    
    // MARK: - Collection View Layout
    
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

}
    // MARK: - Collection View Methods

    extension AllProductsViewController :
        UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.products.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
            let item = viewModel.products[indexPath.row]
            
            cell.brandLabel.text = item.vendor
            
            let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                  let exchangeRate = viewModel.exchangeRates[selectedCurrency] ?? 1.0
                  
                  if let price = Double(item.variants[0].price) {
                      let convertedPrice = price * exchangeRate
                      cell.priceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(selectedCurrency)"
                  } else {
                      cell.priceLabel.text = "Invalid price"
                  }
            
            if let range = item.title.range(of: "|") {
                var truncatedString = String(item.title[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                
                if let nextRange = truncatedString.range(of: "|") {
                    truncatedString = String(truncatedString[..<nextRange.lowerBound]).trimmingCharacters(in: .whitespaces)
                    cell.productNameLabel.text = truncatedString
                }
                cell.productNameLabel.text = truncatedString
            }
            let imageURL = URL(string: item.images[0].src)
            cell.productImage.kf.setImage(with: imageURL)
            
            
            let isFavorite = viewModel.isProductFavorite(productId: "\(viewModel.products[indexPath.row].id)")
            
            cell.configure(with: "\(viewModel.products[indexPath.row].id)", isFavorite: isFavorite, index: indexPath.row)
            
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            viewModel.getproductId(index: indexPath.row)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            navigationController?.pushViewController(brandsViewController, animated: true)
          }
     
    }


extension AllProductsViewController: ProductsCollectionViewCellDelegate{

    
    
    func didTapFavoriteButton(index: Int) {
        viewModel.getproductId(index: index)
        print("fff index: \(index)")
        collectionView.reloadData()
    }
    
    
    func productsCollectionViewCellDidToggleFavorite(at index: Int) {
        guard index < viewModel.products.count else { return }
        
        viewModel.toggleFavorite(productId:  "\(viewModel.products[index].id)") { error in
            if let error = error {
                print("Error toggling favorite status: \(error.localizedDescription)")
                // Handle error if needed
            } else {
                // Update UI or perform any post-toggle actions
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
