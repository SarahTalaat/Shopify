//
//  AllProductsViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 04/06/2024.
//

import UIKit
import Kingfisher

class AllProductsViewController: UIViewController , UISearchBarDelegate{

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    
    let viewModel = AllProductsViewModel()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserFavorites()
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "All Products"
            let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
            collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
            collectionView.collectionViewLayout = brandsCollectionViewLayout()
            search.delegate = self
            viewModel.bindAllProducts = {
                self.updateCollection()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              tapGesture.cancelsTouchesInView = false
              view.addGestureRecognizer(tapGesture)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
        
             func updateCollection(){
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        
        // MARK: - UISearchBarDelegate Methods

        @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.filterProducts(by: searchText)
        }
        
        @objc func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
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
                return viewModel.filteredProducts.count
            }
            
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
                let item = viewModel.filteredProducts[indexPath.row]
                
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
        
        if viewModel.isGuest() == false {
           
        }else{
            guard index < viewModel.filteredProducts.count else { return }
            let productId = "\(viewModel.filteredProducts[index].id)"
            viewModel.toggleFavorite(productId: productId) { error in
                if let error = error {
                    print("Error toggling favorite status: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        

    }


    

         func productsCollectionViewCellDidToggleFavorite(at index: Int) {
             guard index < viewModel.filteredProducts.count else { return }
             
             if viewModel.isGuest() == false {
                 showAlerts(title:"Guest Access Restricted",message:"Please sign in to access this feature.")
             }else{
                 viewModel.toggleFavorite(productId:  "\(viewModel.filteredProducts[index].id)") { error in
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
    }
