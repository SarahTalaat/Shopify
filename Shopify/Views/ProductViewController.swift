//
//  ProductViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit
import Kingfisher

class ProductViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var price: UISlider!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeMenu: UIButton!
    @IBOutlet weak var colorMenu: UIButton!   
    @IBOutlet weak var collectionViewTopConstraint: UICollectionViewCell!
    
    @IBOutlet weak var containerView: UIView!
    @IBAction func priceBar(_ sender: Any) {
             self.updateFilteredProducts()
         
    }
    
    let colorList = ["Black", "White", "Red", "Blue", "Green", "Brown"]
    let sizeList = ["XS", "S", "M", "L", "XL"]
    var isFilter = false
    var viewModel = ProductViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        collectionView.collectionViewLayout = brandsCollectionViewLayout()
        
        containerView.isHidden = true
        priceLabel.text = "No selected price"
        
        handleDropDownList()
        filterByPrice()
        
        viewModel.bindProducts = { [weak self] in
            self?.updateCollection()
            self?.filterByPrice()
        }
    

    }

    func updateCollection(){
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    
    
    // MARK: - Filter By Price
    func filterByPrice() {
        let priceArray = viewModel.productsPrice.compactMap { Float($0) }
        if let minPrice = priceArray.min(), let maxPrice = priceArray.max() {
            price.minimumValue = minPrice
            price.maximumValue = maxPrice
            price.value = maxPrice 
        }
    }
    
    func updateFilteredProducts() {
        let filteredPrice = price.value
            priceLabel.text = "Price: \(filteredPrice)"
            
        let minPrice = viewModel.productsPrice.compactMap { Float($0) }.min()
            let filteredArray = viewModel.products.filter { product in
                product.variants.contains { variant in
                    if let variantPrice = Float(variant.price) {
                        return variantPrice >= minPrice ?? 0.0 && variantPrice <= filteredPrice
                    }
                    return false
                }
            }
            viewModel.products = filteredArray
            collectionView.reloadData()
    }

    
    
    // MARK: - Drop Down List
    
    func handleDropDownList(){
        let actionClosure = { (action: UIAction) in
            print(action.title)
        }

        //Color Menu
        var menuColors: [UIMenuElement] = []
        for fruit in colorList {
            menuColors.append(UIAction(title: fruit, handler: actionClosure))
        }
        colorMenu.menu = UIMenu(options: .displayInline, children: menuColors)
        colorMenu.showsMenuAsPrimaryAction = true
        colorMenu.changesSelectionAsPrimaryAction = true
        
        //Size Menu
        var menusizes: [UIMenuElement] = []
        for fruit in sizeList {
            menusizes.append(UIAction(title: fruit, handler: actionClosure))
        }
        sizeMenu.menu = UIMenu(options: .displayInline, children: menusizes)
        sizeMenu.showsMenuAsPrimaryAction = true
        sizeMenu.changesSelectionAsPrimaryAction = true
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(self.showFilter))
        navigationItem.rightBarButtonItems = [filterButton]
    }
  
    

    // MARK: - Navigation Bar Item
    
    @objc func showFilter(){
        
        if isFilter{
            containerView.isHidden = true
            isFilter = false
        } else{
            containerView.isHidden = false
            isFilter = true
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
                   section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 4)
                   
                   return section
        }
    }
}


// MARK: - Collection View Methods

extension ProductViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.products[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.brandLabel.text = item.vendor
        if let price = item.variants.first?.price {
            cell.priceLabel.text = "\(price)$"

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
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        navigationController?.pushViewController(brandsViewController, animated: true)
      }
    
    
    
    
}
