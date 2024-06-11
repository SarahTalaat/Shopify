//
//  ProfileViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var gmailLabel: UILabel!
    @IBOutlet weak var ordersLabel: UILabel!
    @IBOutlet weak var wishlistLabel: UILabel!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    var sharedMethods: SharedMethods?
    
    var userProfileViewModel: UserProfileViewModelProfileProtocol!
    
    @IBAction func ordersBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
                 let orders = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
                 navigationController?.pushViewController(orders, animated: true)
    }
    
    
    @IBAction func wishlistBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        navigationController?.pushViewController(favouriteVC, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        ordersCollectionView.collectionViewLayout = ordersCollectionViewLayout()
        wishlistCollectionView.collectionViewLayout = wishlistCollectionViewLayout()
        sharedMethods = SharedMethods(viewController: self)
        
        
        print("Profile View Controller ViewDidLoad")
        userProfileViewModel = DependencyProvider.userProfileViewModel
        bindViewModel() 
        
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))
        
        let thirdButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToSettings))

        navigationItem.rightBarButtonItems = [firstButton, secondButton]
        navigationItem.leftBarButtonItem = thirdButton
        
        login.isHidden = true
        register.isHidden = true
        
       
    }
    
    private func bindViewModel() {
        userProfileViewModel.bindUserViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                self?.welcomeLabel.text = "Welcome\(self?.userProfileViewModel?.name)"
                print("Profile: View: name: \(self?.userProfileViewModel?.name ?? "Nope there is no value for name!!!")")
                self?.usernameLabel.text = self?.userProfileViewModel?.name
                self?.gmailLabel.text = self?.userProfileViewModel?.email
            }
        }
    }
    
    
    func ordersCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 5, bottom: 10, trailing: 5)

            return section
        }
    }
    
    func wishlistCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 5, bottom: 4, trailing: 5)
            return section
        }
    }

}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ordersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderCollectionViewCell", for: indexPath) as! OrderCollectionViewCell
            cell.creationDate.text = "Created At: 2024-6-22"
            cell.orderPrice.text = "200$"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCollectionViewCell", for: indexPath) as! WishlistCollectionViewCell
            cell.productName.text = "Black Dress"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ordersCollectionView {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
                     let orders = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                     navigationController?.pushViewController(orders, animated: true)
        } else {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        navigationController?.pushViewController(favouriteVC, animated: true)
            }
        }
    }

@IBDesignable extension UIView
{
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

//class ShadowedCollectionView: UICollectionView {
//    
//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: frame, collectionViewLayout: layout)
//        setupShadow()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupShadow()
//    }
//    
//    private func setupShadow() {
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.25
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowRadius = 4
//        layer.masksToBounds = false
//        layer.cornerRadius = 10  // Optional: if you want rounded corners
//    }
//}
