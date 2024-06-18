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
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var wishlistView: UIView!
    
    
    let viewModel = UserProfileViewModel()
    var detailsModel = OrderDetailsViewModel()
    var sharedMethods: SharedMethods?
    var userProfileViewModel: UserProfileViewModelProfileProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersCollectionView.collectionViewLayout = ordersCollectionViewLayout()
        wishlistCollectionView.collectionViewLayout = wishlistCollectionViewLayout()
        sharedMethods = SharedMethods(viewController: self)
        
        print("Profile View Controller ViewDidLoad")
        userProfileViewModel = DependencyProvider.userProfileViewModel
        bindViewModel()
        userProfileViewModel.userPersonalData()
        print("Profile: test name : \(userProfileViewModel.name)")
        print("Profile: test email : \(userProfileViewModel.email)")

        let secondButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToCart))

        let thirdButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToSettings))

        navigationItem.rightBarButtonItems = [secondButton]
        navigationItem.leftBarButtonItem = thirdButton
        
        login.isHidden = true
        register.isHidden = true
        
        guestMode()
        
        viewModel.bindAllOrders = {
          self.updateCollection()
        }
    }
    

    func updateCollection(){
            DispatchQueue.main.async { [weak self] in
                self?.ordersCollectionView.reloadData()
                self?.ordersLabel.text = "You have \(self?.viewModel.orders.count) orders"
            }
        }
    
 
    
    private func bindViewModel() {
        userProfileViewModel.bindUserViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                self?.welcomeLabel.text = "Welcome \(self?.userProfileViewModel?.name ?? "No valueeee for name!!!!!")"
                print("Profile: View: name: \(self?.userProfileViewModel?.name ?? "Nope there is no value for name!!!")")
                if self?.userProfileViewModel?.name == "Guest" {
                    self?.usernameLabel.text  = "Join us to enjoy exclusive features!"
                    
                    self?.gmailLabel.text = "View and manage your orders,create a personalized wishlist and receive special offers and discounts"

                }else{
                    self?.usernameLabel.text = self?.userProfileViewModel?.name
                    self?.gmailLabel.text = self?.userProfileViewModel?.email

                }
            }
        }
    }
    func guestMode(){
        if userProfileViewModel.name == "Guest"{
            login.isHidden = false
            register.isHidden = false
            ordersCollectionView.isHidden = true
            wishlistCollectionView.isHidden = true
            ordersView.isHidden = true
            wishlistView.isHidden = true
        }
    }
    
    // MARK: - Handle Buttons Action
    
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
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(signInVC, animated: true)

    }
    
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = sb.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(signUpVC, animated: true)

    }
    
    // MARK: - Collection View Layout Drawing
    
    func ordersCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(80))
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

// MARK: - UICollectionView Methods

    extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
             return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch collectionView
            {
            case ordersCollectionView :
                return min(viewModel.orders.count, 2)
            default:
                return 2
            }
              
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == ordersCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderCollectionViewCell", for: indexPath) as! OrderCollectionViewCell
                
                
                let item = viewModel.orders[indexPath.row]
                
                let date = item.created_at
                let datePart = date?.split(separator: "T").first.map(String.init)
                cell.creationDate.text = "Created At: \(datePart ?? " ")"
                
                if let totalPrice = item.total_price {
                            cell.orderPrice.text = "\(totalPrice)$"
                        } else {
                            cell.orderPrice.text = "0.00$"
                        }

                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCollectionViewCell", for: indexPath) as! WishlistCollectionViewCell
                cell.productName.text = "Black Dress"
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == ordersCollectionView {
                detailsModel.id = viewModel.orders[indexPath.row].id ?? 0
                 let storyboard = UIStoryboard(name: "Second", bundle: nil)
                 let orderDetailsViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                orderDetailsViewController.viewModel = detailsModel

                 navigationController?.pushViewController(orderDetailsViewController, animated: true)
            } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let favouriteVC = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
            navigationController?.pushViewController(favouriteVC, animated: true)
                }
            }
        }

// MARK: - Shadow Effect

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

