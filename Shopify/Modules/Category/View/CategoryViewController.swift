//
//  CategoryViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class CategoryViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var shoesBtn: UIButton!
    @IBOutlet weak var bagsBtn: UIButton!
    @IBOutlet weak var clothBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var women: UIButton!

    @IBAction func backToHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                navigationController?.pushViewController(homeViewController, animated: true)
            }
        print("back")
    }
    var shoesButtonCenter: CGPoint!
    var bagsButtonCenter: CGPoint!
    var clothButtonCenter: CGPoint!
    var isButtonMenuOpen = false
    var sharedMethods: SharedMethods?
    var selectedButton: UIButton?
    var isSearch = false
    let viewModel = CategoryViewModel()
    
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
            collectionView.collectionViewLayout = productCollectionViewLayout()
            sharedMethods = SharedMethods(viewController: self)
            
            shoesButtonCenter = shoesBtn.center
            bagsButtonCenter = bagsBtn.center
            clothButtonCenter = clothBtn.center

            shoesBtn.center = allBtn.center
            bagsBtn.center = allBtn.center
            clothBtn.center = allBtn.center

            shoesBtn.alpha = 0
            bagsBtn.alpha = 0
            clothBtn.alpha = 0

        
        collectionView.reloadData()
            
            shoesBtn.applyShadow()
            bagsBtn.applyShadow()
            clothBtn.applyShadow()
            setNavBarItems()
           
            women.addBottomBorder(withColor: UIColor.red, andWidth: 2)
            selectedButton = women
            search.delegate = self

            
            viewModel.bindCategory = {
                self.updateCollection()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              tapGesture.cancelsTouchesInView = false
              view.addGestureRecognizer(tapGesture)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
        
         
        
         
          func updateButton(_ sender: UIButton,id:CategoryID) {
                selectedButton?.removeBottomBorder()
                sender.addBottomBorder(withColor: UIColor.red, andWidth: 2)
                selectedButton = sender
              viewModel.getCategory(id: id)
            }
          func updateCollection(){
                  DispatchQueue.main.async {
                      self.collectionView.reloadData()
                  }
              }

      //MARK: - Buttons Actions
      @IBAction func womenBtn(_ sender: UIButton) {
          updateButton(sender,id:.women)
      }
      @IBAction func MenBtn(_ sender: UIButton) {
          updateButton(sender,id:.men)
      }
      @IBAction func childrenBtn(_ sender: UIButton) {
          updateButton(sender,id:.kids)
      }
      @IBAction func saleBtn(_ sender: UIButton) {
          updateButton(sender,id:.sale)
      }
      @IBAction func searchTextField(_ sender: UITextField) {
      }
      @IBAction func shoesButton(_ sender: UIButton) {
          viewModel.filterBySubCategory(subcategory: .shoes)
      }
      @IBAction func bagButton(_ sender: UIButton) {
          viewModel.filterBySubCategory(subcategory: .bag)
   
      }
      @IBAction func clothButton(_ sender: UIButton) {
          viewModel.filterBySubCategory(subcategory: .cloth)
   
      }
   
      @IBAction func allButton(_ sender: UIButton) {
          viewModel.filterBySubCategory(subcategory: .all)
             }
   

    
      // MARK: - Navigation Bar Item

    func setNavBarItems(){
              let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))
              let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))
       
              navigationItem.rightBarButtonItems = [secondButton,firstButton]
     }
      // MARK: - FAB Button Design
      @IBAction func didClickMoreButton(_ sender: UIButton) {
          if isButtonMenuOpen {UIView.animate(withDuration: 0.3) {
              self.shoesBtn.center = self.allBtn.center
              self.bagsBtn.center = self.allBtn.center
              self.clothBtn.center = self.allBtn.center
              self.shoesBtn.alpha = 0
              self.bagsBtn.alpha = 0
              self.clothBtn.alpha = 0
          }
                  self.isButtonMenuOpen = false
          } else {
              UIView.animate(withDuration: 0.3){
                  self.shoesBtn.center = self.shoesButtonCenter
                  self.bagsBtn.center = self.bagsButtonCenter
                  self.clothBtn.center = self.clothButtonCenter
                  self.shoesBtn.alpha = 1
                  self.bagsBtn.alpha = 1
                  self.clothBtn.alpha = 1
              }
                  self.isButtonMenuOpen = true
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
      func productCollectionViewLayout() -> UICollectionViewCompositionalLayout {
          return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
              let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(1.0))
              let item = NSCollectionLayoutItem(layoutSize: itemSize)
              let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(130))
              let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
              let section = NSCollectionLayoutSection(group: group)
              section.interGroupSpacing = 10
              section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 4, bottom: 10, trailing: 4)
   
              return section
          }
      }
  }
   
      // MARK: - Collection View Methods
   
extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
          func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
              return viewModel.filteredProducts.count
          }

          func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
              let item = viewModel.filteredProducts[indexPath.row]
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell

              cell.productBrand.text = item.vendor
              viewModel.getPrice(id: item.id) { price in
                         let selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                         let exchangeRate = self.viewModel.exchangeRates[selectedCurrency] ?? 1.0
                         if let priceDouble = Double(price) {
                             let convertedPrice = priceDouble * exchangeRate
                             DispatchQueue.main.async {
                                 cell.productPrice.text = "\(String(format: "%.2f", convertedPrice)) \(selectedCurrency)"
                             }
                         }
                     }
              if let range = item.title.range(of: "|") {
                  var truncatedString = String(item.title[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                  if let nextRange = truncatedString.range(of: "|") {
                      truncatedString = String(truncatedString[..<nextRange.lowerBound]).trimmingCharacters(in: .whitespaces)
                      cell.productName.text = truncatedString
                  }
                  cell.productName.text = truncatedString
              }
              let imageURL = URL(string: item.image.src)
              cell.categoryImage.kf.setImage(with: imageURL)
              let isFavorite = viewModel.isProductFavorite(productId: "\(viewModel.category[indexPath.row].id)")
            

            cell.configure(with: "\(viewModel.category[indexPath.row].id)", isFavorite: isFavorite, index: indexPath.row)
            
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


extension CategoryViewController: ProductsTableViewCellDelegate{



    func didTapFavoriteButton(index: Int) {
        guard index < viewModel.filteredProducts.count else { return }
        
        if viewModel.isGuest() == false {
            showAlerts(title:"Guest Access Restricted",message:"Please sign in to access this feature.")
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

         
         
     func productsTableViewCellDidToggleFavorite(at index: Int) {
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

      // MARK: - Button Design
   
extension UIButton {
    func applyShadow() {
        layer.shadowOpacity = 0.6
    }
    func addBottomBorder(withColor color: UIColor, andWidth borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        border.name = "bottomBorder"
        self.layer.addSublayer(border)
    }
    
    func removeBottomBorder() {
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                if layer.name == "bottomBorder" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

