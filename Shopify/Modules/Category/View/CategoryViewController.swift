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
    @IBAction func womenBtn(_ sender: UIButton) {
        updateButton(sender)
    }
    
    @IBAction func MenBtn(_ sender: UIButton) {
        updateButton(sender)
    }
    
    @IBAction func childrenBtn(_ sender: UIButton) {
        updateButton(sender)
    }
    
    @IBAction func saleBtn(_ sender: UIButton) {
        updateButton(sender)
    }
    
    @IBAction func searchTextField(_ sender: UITextField) {
    }
    var shoesButtonCenter: CGPoint!
    var bagsButtonCenter: CGPoint!
    var clothButtonCenter: CGPoint!
    var isButtonMenuOpen = false
    var sharedMethods: SharedMethods?
    var selectedButton: UIButton?
    var isSearch = false
    
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
        
        
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.showSearch))

        navigationItem.rightBarButtonItems = [firstButton, secondButton]
        navigationItem.leftBarButtonItem = searchButton
        search.isHidden = true
        
        women.addBottomBorder(withColor: UIColor.red, andWidth: 2)
        selectedButton = women
    }
    
    @objc func showSearch(){
        
        if isSearch{
            search.isHidden = true
            isSearch = false

        }else{
            search.isHidden = false
            isSearch = true

        }

    }
    

    //Setting FAB Button
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
    
    
    func updateButton(_ sender: UIButton) {
          selectedButton?.removeBottomBorder()
          sender.addBottomBorder(withColor: UIColor.red, andWidth: 2)
          selectedButton = sender
      }
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 4, bottom: 5, trailing: 4)

            return section
        }
    }
    
    
}

extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.productBrand.text = "Zara"
        cell.productPrice.text = "9$"
        cell.productName.text = "Black Dress"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                     navigationController?.pushViewController(brandsViewController, animated: true)
      }
}
    

extension UIButton {
    func applyShadow() {
        layer.shadowOpacity = 0.6
    }
    
    func addBottomBorder(withColor color: UIColor, andWidth borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        border.name = "bottomBorder" // Tag the border layer
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
