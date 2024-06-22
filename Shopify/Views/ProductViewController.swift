//
//  ProductViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit
import Kingfisher


class ProductViewController: UIViewController , UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeMenu: UIButton!
    @IBOutlet weak var clothSizeMenu: UIButton!
    @IBOutlet weak var colorMenu: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    let colorList = ["All","black", "white", "red", "blue", "gray", "yellow","beige","light-brown","burgandy"]
    let sizeList = ["All","1","2","3","4","5","6","7","8","9","10","11","12","13","14"]
    let clothList = [ "All","S", "M", "L", "XL"]
    var isFilter = false
    var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
            collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
            collectionView.collectionViewLayout = brandsCollectionViewLayout()
         
            search.delegate = self
            containerView.isHidden = false
            priceLabel.text = "No selected price"
            
            handleDropDownList()
            
            viewModel.bindFilteredProducts = { [weak self] in
                self?.updateCollection()
            }
            
            viewModel.bindPriceRange = { [weak self] in
                self?.updatePriceRange()
            }
            
            priceSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tapGesture.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture)
     }

     @objc func dismissKeyboard() {
         view.endEditing(true)
     }
     
        
        func updateCollection() {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        // MARK: - Filter By Price
        
     @objc func sliderValueChanged(_ sender: UISlider) {
                priceLabel.text = String(format: "Price: %.2f", sender.value)
                viewModel.currentMaxPrice = sender.value
            }
            
         func updatePriceRange() {
             DispatchQueue.main.async {
                 self.priceSlider.minimumValue = self.viewModel.minPrice
                 self.priceSlider.maximumValue = self.viewModel.maxPrice
                 self.priceSlider.value = self.viewModel.currentMaxPrice
                 self.priceLabel.text = String(format: "Price: %.2f %@", self.viewModel.currentMaxPrice, UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD")
             }
         }
            // MARK: - Drop Down List
            
            func handleDropDownList() {
                setupMenuButton(button: sizeMenu, items: sizeList) { [weak self] selected in
                    guard let self = self else { return }
                    if selected == "All" {
                        self.viewModel.currentFilters.size = nil
                    } else {
                        self.viewModel.currentFilters.size = ("SHOES", selected)
                    }
                }
                
                setupMenuButton(button: clothSizeMenu, items: clothList) { [weak self] selected in
                    guard let self = self else { return }
                    if selected == "All" {
                        self.viewModel.currentFilters.size = nil
                    } else {
                        self.viewModel.currentFilters.size = ("T-SHIRTS", selected)
                    }
                }
                
                setupMenuButton(button: colorMenu, items: colorList) { [weak self] selectedColor in
                    guard let self = self else { return }
                    if selectedColor == "All" {
                        self.viewModel.currentFilters.color = nil
                    } else {
                        self.viewModel.currentFilters.color = selectedColor
                    }
                }
                
                let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(self.showFilter))
                navigationItem.rightBarButtonItems = [filterButton]
            }
            
            private func setupMenuButton(button: UIButton, items: [String], action: @escaping (String) -> Void) {
                var actions: [UIAction] = []
                for item in items {
                    let uiAction = UIAction(title: item) { _ in
                        action(item)
                    }
                    actions.append(uiAction)
                }
                button.menu = UIMenu(title: "", options: .displayInline, children: actions)
                button.showsMenuAsPrimaryAction = true
                button.changesSelectionAsPrimaryAction = true
            }
            
        // MARK: - Navigation Bar Item
        
        @objc func showFilter() {
            containerView.isHidden.toggle()
            isFilter.toggle()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
     
     // MARK: - UISearchBarDelegate Methods

     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         viewModel.searchQuery = searchText
     }
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
             searchBar.resignFirstResponder()
         }
     
        // MARK: - Collection View Layout
        
        func brandsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
            return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(260))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 4)
                
                return section
            }
        }
    }



         // MARK: - Collection View Methods

         extension ProductViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
             func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                 return viewModel.filteredProducts.count
             }
             
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                 
                 let item = viewModel.filteredProducts[indexPath.row]
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
                 
                 cell.brandLabel.text = item.vendor
                 
                 let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                       let exchangeRate = viewModel.exchangeRates[selectedCurrency] ?? 1.0
                       if let price = Double(item.variants.first?.price ?? "0") {
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
                 
                 if let imageUrlString = item.images.first?.src, let imageURL = URL(string: imageUrlString) {
                     cell.productImage.kf.setImage(with: imageURL)
                 }
                 
                 let isFavorite = viewModel.isProductFavorite(productId: "\(viewModel.filteredProducts[indexPath.row].id)")
                 

                 cell.configure(with: "\(viewModel.filteredProducts[indexPath.row].id)", isFavorite: isFavorite, index: indexPath.row)
                 
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




extension ProductViewController: ProductsCollectionViewCellDelegate{

         
    func didTapFavoriteButton(index: Int) {
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

         
         
         func productsCollectionViewCellDidToggleFavorite(at index: Int) {
             guard index < viewModel.filteredProducts.count else { return }
             
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
