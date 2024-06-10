//
//  CategoryViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var shoesBtn: UIButton!
    @IBOutlet weak var bagsBtn: UIButton!
    @IBOutlet weak var clothBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var women: UIButton!

    var shoesButtonCenter: CGPoint!
    var bagsButtonCenter: CGPoint!
    var clothButtonCenter: CGPoint!
    var isButtonMenuOpen = false
    var sharedMethods: SharedMethods?
    var selectedButton: UIButton?
    var isSearch = false
    let viewModel = CategoryViewModel()
    
    
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

        
        shoesBtn.applyShadow()
        bagsBtn.applyShadow()
        clothBtn.applyShadow()
        setNavBarItems()
       
        women.addBottomBorder(withColor: UIColor.red, andWidth: 2)
        selectedButton = women
        
        viewModel.bindCategory = {
            self.updateCollection()
        }
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
    
    @objc func showSearch(){
        if isSearch{
            search.isHidden = true
            isSearch = false
        }else{
            search.isHidden = false
            isSearch = true
        }
    }
    
    func setNavBarItems(){
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.showSearch))

        navigationItem.rightBarButtonItems = [firstButton, secondButton]
        navigationItem.leftBarButtonItem = searchButton
        search.isHidden = true
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
            return viewModel.category.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let item = viewModel.category[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
            
            cell.productBrand.text = item.vendor
            viewModel.getPrice(id: item.id) { price in
                       DispatchQueue.main.async {
                           cell.productPrice.text = "\(price)$"
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
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                         navigationController?.pushViewController(brandsViewController, animated: true)
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
