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
    var favouriteViewModel: FavouriteViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersCollectionView.collectionViewLayout = ordersCollectionViewLayout()
        wishlistCollectionView.collectionViewLayout = wishlistCollectionViewLayout()
        sharedMethods = SharedMethods(viewController: self)
     
        wishlistCollectionView.reloadData()
       
        print("Profile View Controller ViewDidLoad")
        userProfileViewModel = DependencyProvider.userProfileViewModel
        favouriteViewModel = DependencyProvider.favouriteViewModel
        favouriteViewModel.retriveProducts()
        
        bindViewModel()
        bindViewModel2()
        userProfileViewModel.userPersonalData()
        print("Profile: test name : \(userProfileViewModel.name)")
        print("Profile: test email : \(userProfileViewModel.email)")

        func bindViewModel(){
            favouriteViewModel.bindProducts = { [weak self] in
                DispatchQueue.main.async {
                    self?.wishlistCollectionView.reloadData()
                }
            }
        }

        let firstButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: sharedMethods, action: #selector(SharedMethods.navToFav))

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
        ordersLabel.text = "You have \(viewModel.orders.count) order"

        print(viewModel.orders.count)
    }

    
    
    func bindViewModel(){
        favouriteViewModel.bindProducts = { [weak self] in
            DispatchQueue.main.async {
                self?.wishlistCollectionView.reloadData()
                self?.wishlistLabel.text = "You have \(self?.favouriteViewModel.products?.count ?? 0) favourite products"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          viewModel.getOrders()
          updateCollection()
        initializeButtonStyles()
        favouriteViewModel.retriveProducts()
        }
        
        func initializeButtonStyles() {
            login.setTitleColor(.customColor, for: .normal)
            login.tintColor = .customBackgroundColor
            
            register.setTitleColor(.customColor, for: .normal)
            register.tintColor = .customBackgroundColor
        }
        
    func updateCollection(){
            DispatchQueue.main.async { [weak self] in
                self?.ordersCollectionView.reloadData()
                self?.ordersLabel.text = "You have \(self?.viewModel.orders.count ?? 5) order"
            }
        }
        
    private func bindViewModel2() {
        userProfileViewModel.bindUserViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                self?.welcomeLabel.text = "Welcome \(self?.userProfileViewModel?.name ?? "No value for name!")"
                print("Profile: View: name: \(self?.userProfileViewModel?.name ?? "there is no value for name!!")")
                
                if self?.viewModel.customerEmail == nil {
                    self?.usernameLabel.text  = "Join us to enjoy exclusive features!"
                    
                    self?.gmailLabel.text = "View your orders,create a personalized wishlist and receive discounts"

                }else{
                    self?.usernameLabel.text = self?.userProfileViewModel?.name
                    self?.gmailLabel.text = self?.userProfileViewModel?.email

                }
            }
        }
    }
    func guestMode(){
        if viewModel.customerEmail == nil{
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
            case wishlistCollectionView:
                return min(favouriteViewModel.products?.count ?? 2, 2)
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
                    cell.orderPrice.text = "\(totalPrice) \(item.currency)"
                        } else {
                            cell.orderPrice.text = "0.00 USD"
                        }

                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCollectionViewCell", for: indexPath) as! WishlistCollectionViewCell
                
                if favouriteViewModel.products?.count == 0 {
                    cell.isHidden = true
                }else if favouriteViewModel.products?.count == 1 {
                    if indexPath.row == 1 {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                        if let product = favouriteViewModel.products?[indexPath.row] {
                            cell.productName.text = product.productTitle
                        }
                    }
              }else{
                    if favouriteViewModel.products?[indexPath.row] != nil {
                    cell.productName.text = favouriteViewModel.products?[indexPath.row].productTitle
                    }
                    
                }
            

                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == ordersCollectionView {
                detailsModel.id = viewModel.orders[indexPath.row].id ?? 0
                detailsModel.currency = viewModel.orders[indexPath.row].currency
                 let storyboard = UIStoryboard(name: "Second", bundle: nil)
                 let orderDetailsViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                orderDetailsViewController.viewModel = detailsModel

                 navigationController?.pushViewController(orderDetailsViewController, animated: true)
            } else {
                favouriteViewModel.getproductId(index: indexPath.row)
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                 navigationController?.pushViewController(brandsViewController, animated: true)
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

extension UIColor {
    static let customColor = UIColor.white // Custom color set to white
    static let customBackgroundColor = UIColor(red: 219/255, green: 48/255, blue: 34/255, alpha: 1.0) // Custom background color set to (219, 48, 34)
}
