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
    var loadingIndicator = UIActivityIndicatorView(style: .large)

    let colorList = ["Colors","black", "white", "red", "blue", "gray", "yellow","beige","light-brown","burgandy"]
    let sizeList = ["Shoes","1","2","3","4","5","6","7","8","9","10","11","12","13","14"]
    let clothList = [ "Cloth","S", "M", "L", "XL"]
    private var pickerViewItems: [String]?

    var isFilter = false
    var viewModel = ProductViewModel()
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
            collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
            collectionView.collectionViewLayout = brandsCollectionViewLayout()
         
            search.delegate = self
            priceLabel.text = "No selected price"
            
            handleDropDownList()
            
            viewModel.bindFilteredProducts = { [weak self] in
                self?.updateCollection()
            }
            
            viewModel.bindPriceRange = { [weak self] in
                self?.updatePriceRange()
            }
        
           sizeMenu.setTitle("Shoes", for: .normal)
           clothSizeMenu.setTitle("Cloth", for: .normal)
           colorMenu.setTitle("Colors", for: .normal)
        
           viewModel.currentFilters.size = nil
            viewModel.currentFilters.color = nil
        
        setupLoadingIndicators()
        loadingIndicator.startAnimating()

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
                self.loadingIndicator.stopAnimating()
            }
        }
    
    func setupLoadingIndicators() {
        collectionView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserFavorites()
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
            
                private func handleDropDownList() {
                    sizeMenu.addTarget(self, action: #selector(showSizeMenu), for: .touchUpInside)
                    clothSizeMenu.addTarget(self, action: #selector(showClothSizeMenu), for: .touchUpInside)
                    colorMenu.addTarget(self, action: #selector(showColorMenu), for: .touchUpInside)
                }
    
            @objc private func showSizeMenu() {
                pickerViewItems = sizeList
                showPickerView(title: "Select Size", items: sizeList) { [weak self] selected in
                    guard let self = self else { return }
                    self.sizeMenu.setTitle(selected, for: .normal)
                    if selected == "Shoes" {
                        self.viewModel.currentFilters.size = nil
                    } else {
                        self.viewModel.currentFilters.size = ("SHOES", selected)
                    }
                }
            }

            @objc private func showClothSizeMenu() {
                pickerViewItems = clothList
                showPickerView(title: "Select Cloth Size", items: clothList) { [weak self] selected in
                    guard let self = self else { return }
                    self.clothSizeMenu.setTitle(selected, for: .normal)
                    if selected == "Cloth" {
                        self.viewModel.currentFilters.size = nil
                    } else {
                        self.viewModel.currentFilters.size = ("T-SHIRTS", selected)
                    }
                }
            }

            @objc private func showColorMenu() {
                pickerViewItems = colorList
                showPickerView(title: "Select Color", items: colorList) { [weak self] selectedColor in
                    guard let self = self else { return }
                    self.colorMenu.setTitle(selectedColor, for: .normal)
                    if selectedColor == "Colors" {
                        self.viewModel.currentFilters.color = nil
                    } else {
                        self.viewModel.currentFilters.color = selectedColor
                    }
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
        
        if viewModel.isGuest() == false {
            showAlerts(title:"Guest Access Restricted",message:"Please sign in to access this feature.")
        }else{
            
            if viewModel.isProductFavorite(productId: "\(viewModel.filteredProducts[index].id)") == true{
                showFavouriteAlerts(title: "Alert!", message: "Are you sure you want to delete this product from favourites?", index: index)
            }else{
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
    }
    
    func showFavouriteAlerts(title: String, message: String , index: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create action for "Yes" button
        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
            // Handle Yes action if needed

            print("Yes button tapped")
            self.viewModel.toggleFavorite(productId:  "\(self.viewModel.filteredProducts[index].id)") { error in
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
        
        // Create action for "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // Handle Cancel action if needed
            print("Cancel button tapped")
        }
        
        // Set text color for "Yes" button to red
        yesAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        // Add actions to the alert controller
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        // Present the alert controller
        self.present(alert, animated: true, completion: nil)
    }

         
         
     func productsCollectionViewCellDidToggleFavorite(at index: Int) {
         guard index < viewModel.filteredProducts.count else { return }
         
         if viewModel.isGuest() == false {
             showAlerts(title:"Guest Access Restricted",message:"Please sign in to access this feature.")
         } else{
             
             if viewModel.isProductFavorite(productId: "\(viewModel.filteredProducts[index].id)") == true{
                 showFavouriteAlerts(title: "Alert!", message: "Are you sure you want to delete this product from favourites?", index: index)
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
    
}
    
    extension ProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
        func showPickerView(title: String, items: [String], selectionHandler: @escaping (String) -> Void) {
            let alertController = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
            
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            
            pickerView.tag = 100
            
            alertController.view.addSubview(pickerView)
            
            let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
                let selectedItem = items[pickerView.selectedRow(inComponent: 0)]
                selectionHandler(selectedItem)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }


        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 100 {
                if let items = pickerViewItems {
                    return items.count
                }
            }
            return 0
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView.tag == 100 {
                if let items = pickerViewItems {
                    return items[row]
                }
            }
            return nil
        }
    
    
//         func productsCollectionViewCellDidToggleFavorite(at index: Int) {
//             guard index < viewModel.filteredProducts.count else { return }
//
//             if viewModel.isGuest() == false {
//                 showGuestAlert()
//             }else{
//                 viewModel.toggleFavorite(productId:  "\(viewModel.filteredProducts[index].id)") { error in
//                     if let error = error {
//                         print("Error toggling favorite status: \(error.localizedDescription)")
//                         // Handle error if needed
//                     } else {
//                         // Update UI or perform any post-toggle actions
//                         DispatchQueue.main.async {
//                             self.collectionView.reloadData()
//                         }
//                     }
//                 }
//             }
//
//
//         }
    
    
     }
