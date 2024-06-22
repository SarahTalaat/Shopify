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
        viewModel.getCustomerId()
        viewModel.getCustomerIDFromFirebase()
        
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
                self?.adsCollectionView.reloadData()
            }
        }
    
       
    // MARK: - Navigation Bar Items 
    
    @objc func navToCart(){
        if SharedDataRepository.instance.customerEmail == nil{
            showGuestAlert()
        }else{
            print("Cart ")
            
            let storyboard = UIStoryboard(name: "Third", bundle: nil)
            let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartViewController
            navigationController?.pushViewController(brandsViewController, animated: true)
        }
        
    }
    
    @objc func navToFav(){
        if SharedDataRepository.instance.customerEmail == nil {
            showGuestAlert()
        }else{
            print("Favourite ")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
            navigationController?.pushViewController(favouriteVC, animated: true)
        }
        
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
                                                   heightDimension: .absolute(165))
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
            return viewModel.coupons.count
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
            let images = ["withsale.jpg","ss.jpg"]
            cell.adsImage.image = UIImage(named: images[indexPath.row])
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
            if SharedDataRepository.instance.customerEmail == nil {
                showGuestAlert()
            }else{
            let item = indexPath.row
            let couponId = viewModel.coupons[item].id
                viewModel.getDiscountCode(id: couponId) { discountCode in
                    guard let discountCode = discountCode else {
                        print("Failed to fetch discount code")
                        return
                    }
                    
                    let discountMessage = item == 0 ? "You have just won a 20% discount coupon, copy this coupon and use it in the checkout process" : "You have just won a 10% discount coupon, copy this coupon and use it in the checkout process"
                    
                    self.showAlertWithTextField(title: "Congratulations!", message: discountMessage, discountCode: discountCode)
                }
            }
        }
    }
}
// MARK: - Alert Handeling

extension UIViewController {
    
    func showAlertWithTextField(title: String, message: String, discountCode: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = discountCode
            textField.isUserInteractionEnabled = true
        }
        
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            if let textField = alertController.textFields?.first {
                UIPasteboard.general.string = textField.text
            }
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(copyAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
     func showGuestAlert() {
           let alert = UIAlertController(title: "Guest Access Restricted", message: "Please sign in to access this feature.", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(okAction)
           
           self.present(alert, animated: true, completion: nil)
       }
}
