//
//  HomeViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 31/05/2024.
//

import UIKit
import Kingfisher


class HomeViewController: UIViewController {
    
    var sharedMethods: SharedMethods?
    var viewModel  = HomeViewModel()
    var vm = ProductViewModel()
    
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsCollectionView.collectionViewLayout = adsCollectionViewLayout()
        brandsCollectionView.collectionViewLayout = brandsCollectionViewLayout()
        
        
        //Brands View Borders
        brandsCollectionView.layer.cornerRadius = 10
        brandsCollectionView.layer.borderWidth = 1.0
        brandsCollectionView.layer.borderColor = UIColor.black.cgColor
        brandsCollectionView.clipsToBounds = true
        
        sharedMethods = SharedMethods(viewController: self)
        
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchBtn))
        
        navigationItem.rightBarButtonItems = [firstButton, secondButton]
        navigationItem.leftBarButtonItems = [searchButton]
        
        viewModel.bindBrandsData = {
            self.updateCollection()
        }
        

        
    }
    
    func updateCollection(){
            DispatchQueue.main.async { [weak self] in
                self?.brandsCollectionView.reloadData()
            }
        }
       
    // MARK: - Navigation Bar Items 
    
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
    
    @objc func searchBtn(){
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        let brandsViewController = storyboard.instantiateViewController(withIdentifier: "AllProductsViewController") as! AllProductsViewController
        navigationController?.pushViewController(brandsViewController, animated: true)
        
    }
    
    
 // MARK: - Collection View Layout Drawing
    
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

}



// MARK: - UICollectionView Methods

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case brandsCollectionView:
            return viewModel.brands.count
        default:
            return 6
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       
        switch collectionView {
        case brandsCollectionView:
         let item = viewModel.brands[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as! BrandsCollectionViewCell
            
            let imageURL = URL(string: item.image.src)
            cell.brandImage.kf.setImage(with: imageURL)
              
            cell.brandLabel.text = item.title
            return cell
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as! AdsCollectionViewCell
            cell.adsImage.image = UIImage(named: "Sale.jpeg")
            return cell
     
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case brandsCollectionView:
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
            let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            vm.brandID = viewModel.brands[indexPath.row].id
            brandsViewController.viewModel = vm
            print(vm.brandID)
            navigationController?.pushViewController(brandsViewController, animated: true)
         default:
         printContent("Ads")
            }
        }
    }

