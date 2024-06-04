//
//  HomeViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 31/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    var sharedMethods: SharedMethods?
    
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    @IBAction func favBtn(_ sender: UIBarButtonItem) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let brandsViewController = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
                         navigationController?.pushViewController(brandsViewController, animated: true)
    }
    
    
    @IBAction func cartBtn(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Third", bundle: nil)
        let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartViewController
        navigationController?.pushViewController(brandsViewController, animated: true)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsCollectionView.collectionViewLayout = adsCollectionViewLayout()
        brandsCollectionView.collectionViewLayout = brandsCollectionViewLayout()
        
        brandsCollectionView.layer.cornerRadius = 10
             brandsCollectionView.layer.borderWidth = 1.0
             brandsCollectionView.layer.borderColor = UIColor.black.cgColor
             brandsCollectionView.clipsToBounds = true

        sharedMethods = SharedMethods(viewController: self)

        let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))

        navigationItem.rightBarButtonItems = [firstButton, secondButton]

        
    }
    
    @objc func navToCart(){
        print("Cart ")

        let storyboard = UIStoryboard(name: "Third", bundle: nil)
        let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartViewController
        navigationController?.pushViewController(brandsViewController, animated: true)

    }
    
    @objc func navToFav(){
        print("Favourite ")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        navigationController?.pushViewController(favouriteVC, animated: true)

    }
    
    

    func adsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 4, bottom: 5, trailing: 4)
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
    }
    
    func brandsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
              let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                    heightDimension: .fractionalHeight(1.0))
              let item = NSCollectionLayoutItem(layoutSize: itemSize)

              let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(180))
              let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
              group.interItemSpacing = .fixed(10)

              let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .absolute(410)) // Adjusted height for two rows
              let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [group, group])
              nestedGroup.interItemSpacing = .fixed(10)

              let section = NSCollectionLayoutSection(group: nestedGroup)
              section.interGroupSpacing = 10
              section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
              section.orthogonalScrollingBehavior = .continuous

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

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as! AdsCollectionViewCell
            cell.adsImage.image = UIImage(named: "Sale.jpeg")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as! BrandsCollectionViewCell
            cell.brandImage.image = UIImage(named: "adidas-logo-design-template-416e301e26d296a75536e1f323a013e0_screen.jpg")
            cell.brandLabel.text = "ADIDAS"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == adsCollectionView {
          printContent("Ads")
        } else {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
                     let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                     navigationController?.pushViewController(brandsViewController, animated: true)
                  }
        }
    }

