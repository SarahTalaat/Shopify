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
    
    
    @IBAction func priceBar(_ sender: Any) {
    }
    
    @IBOutlet weak var sizeMenu: UIButton!
    @IBOutlet weak var colorMenu: UIButton!
    
    let colorList = ["Black", "White", "Red", "Blue", "Green", "Brown"]
    let sizeList = ["XS", "S", "M", "L", "XL"]
    var isFilter = false
    var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        collectionView.collectionViewLayout = brandsCollectionViewLayout()
        
        priceLabel.isHidden = true
        sizeMenu.isHidden = true
        colorMenu.isHidden = true
        price.isHidden = true
        
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
        
        viewModel.bindProducts = {
            self.updateCollection()
        }

    }
    
    func updateCollection(){
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    
    @objc func showFilter(){
        
        if isFilter{
            priceLabel.isHidden = true
            sizeMenu.isHidden = true
            colorMenu.isHidden = true
            price.isHidden = true
            isFilter = false
        } else{
            priceLabel.isHidden = false
            sizeMenu.isHidden = false
            colorMenu.isHidden = false
            price.isHidden = false
            isFilter = true
        }
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
}


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
            let truncatedString = String(item.title[range.upperBound...]).trimmingCharacters(in: .whitespaces)
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
