//
//  ProductViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class ProductViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func backBtn(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Second", bundle: nil)
//        let homeScreen = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        navigationController?.pushViewController(homeScreen, animated: true)
    }
    
    @IBAction func filterBtn(_ sender: UIBarButtonItem) {
    }
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func priceBar(_ sender: Any) {
    }
    

    @IBOutlet weak var sizeMenu: UIButton!
    
    @IBOutlet weak var colorMenu: UIButton!
    
    let colorList = ["Black", "White", "Red", "Blue", "Green", "Brown"]
    let sizeList = ["XS", "S", "M", "L", "XL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        
        collectionView.collectionViewLayout = brandsCollectionViewLayout()
        
        
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

    }
    
    
    func brandsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProductViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.brandLabel.text = "Zara"
        cell.priceLabel.text = "9$"
        cell.productNameLabel.text = "Black Dress"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                     let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//                     navigationController?.pushViewController(brandsViewController, animated: true)
      }
    
    
    
    
}
