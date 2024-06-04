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
    @IBAction func cartBtn(_ sender: UIBarButtonItem) {
        //        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        //                 let brandsViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        //                 navigationController?.pushViewController(brandsViewController, animated: true)
    }
    
    
    @IBAction func favBtn(_ sender: UIBarButtonItem) {
        //        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        //                 let brandsViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        //                 navigationController?.pushViewController(brandsViewController, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: UIBarButtonItem) {

    }
    
    @IBAction func womenBtn(_ sender: UIButton) {
    }
    
    @IBAction func MenBtn(_ sender: UIButton) {
    }
    
    @IBAction func childrenBtn(_ sender: UIButton) {
    }
    
    @IBAction func saleBtn(_ sender: UIButton) {
    }
    
    @IBAction func searchTextField(_ sender: UITextField) {
    }
    var shoesButtonCenter: CGPoint!
    var bagsButtonCenter: CGPoint!
    var clothButtonCenter: CGPoint!
    var isButtonMenuOpen = false
    
    var sharedMethods: SharedMethods?
    
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
        
        let thirdButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToSettings))

        navigationItem.rightBarButtonItems = [firstButton, secondButton]
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
}
