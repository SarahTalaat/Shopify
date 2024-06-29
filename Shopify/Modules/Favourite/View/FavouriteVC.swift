//
//  FavouriteVC.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit
import Kingfisher

class FavouriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var favouriteTableView: UITableView!
    let backButton = UIBarButtonItem()
    var window: UIWindow?
    let cellSpacingHeight: CGFloat = 30
    
    let emptyTableViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    var viewModel: FavouriteViewModel!
    
    @IBOutlet weak var emptyTableViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUpFavouriteTableView()
        viewModel = DependencyProvider.favouriteViewModel
        
        viewModel.networkStatusChanged = { isReachable in
                  if !isReachable {
                      self.showAlerts(title: "No Internet Connection", message: "Please check your WiFi connection.")
                  }
              }
        
        viewModel.retriveProducts()
        
        bindViewModel()
 
        emptyTableViewImage.image = UIImage(named: "NoFavourite.png")

        
        view.addSubview(emptyTableViewImage)
        
        // Set up constraints for the image view
        emptyTableViewImage.translatesAutoresizingMaskIntoConstraints = false
        emptyTableViewImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyTableViewImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyTableViewImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emptyTableViewImage.heightAnchor.constraint(equalToConstant: 200).isActive = true

        
        
        favouriteTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retriveProducts()
        favouriteTableView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    func bindViewModel(){
        viewModel.bindProducts = { [weak self] in
            DispatchQueue.main.async {
                self?.favouriteTableView.reloadData()
                self?.updatePlaceholder()
            }
        }
    }
    
    func updatePlaceholder() {
        if let products = viewModel.products, !products.isEmpty {
            favouriteTableView.isHidden = false
            emptyTableViewImage.isHidden = true
        } else {
            favouriteTableView.isHidden = true
            emptyTableViewImage.isHidden = false
        }
    }
    
    
    
    func settingUpFavouriteTableView(){
        // Register the custom cell
        let nib = UINib(nibName: "FavouritesCustomCell", bundle: nil)
        favouriteTableView.register(nib, forCellReuseIdentifier: "cell")

        favouriteTableView.dataSource = self
        favouriteTableView.delegate = self
        
        // Set table view properties
       // favouriteTableView.separatorStyle = .none // Remove default separators
        favouriteTableView.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavouritesCustomCell
        

        cell.vendorLabel.text = viewModel.products?[indexPath.row].productVendor
        
        if let range = viewModel.products?[indexPath.row].productTitle.range(of: "|") {
            var truncatedString = String(viewModel.products?[indexPath.row].productTitle[range.upperBound...] ?? "" ).trimmingCharacters(in: .whitespaces)
            if let nextRange = truncatedString.range(of: "|") {
                truncatedString = String(truncatedString[..<nextRange.lowerBound]).trimmingCharacters(in: .whitespaces)
                cell.titleLabel.text = truncatedString
                cell.titleLabel.numberOfLines = 0
                cell.titleLabel.lineBreakMode = .byWordWrapping
            }
            cell.titleLabel.text = truncatedString
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.lineBreakMode = .byWordWrapping
        }
        
//
//         cell.titleLabel.numberOfLines = 1
//         cell.titleLabel.adjustsFontSizeToFitWidth = true
////         cell.titleLabel.minimumScaleFactor = 0.5
//
//         cell.titleLabel.lineBreakMode = .byTruncatingTail
      //  cell.titleLabel.text = viewModel.products?[indexPath.row].productTitle
        
        if let imageUrl = URL(string:viewModel.products?[indexPath.row].productImage ?? "https://m.media-amazon.com/images/I/81H0Mn0kaNL._AC_SL1500_.jpg" ) {
            cell.favImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholderImage"))
        } else {
            cell.favImage.image = UIImage(named: "imageplaceholder.jpg")
        }
        

        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    // Set the height for each row
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            viewModel.deleteProductFromFirebase(index: indexPath.row)
            viewModel.products?.remove(at: indexPath.row)
            favouriteTableView.reloadData()
            updatePlaceholder()
        
        }
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            // Reset the background color for every cell
//            cell.contentView.backgroundColor = UIColor.systemGray6
//
//            // Remove existing custom views if any (to avoid multiple overlays)
//            for subview in cell.contentView.subviews where subview.tag == 1001 || subview.tag == 1002 {
//                subview.removeFromSuperview()
//            }
//
//            // Add the custom white rounded corner view
//            let whiteRoundedCornerView = UIView(frame: CGRect(x: 10, y: 10, width: cell.contentView.frame.width - 20, height: cell.contentView.frame.height - 40))
//            whiteRoundedCornerView.backgroundColor = UIColor.white
//            whiteRoundedCornerView.layer.masksToBounds = false
//            whiteRoundedCornerView.layer.cornerRadius = 10
//            whiteRoundedCornerView.layer.shadowOffset = CGSize(width: -1, height: 1)
//            whiteRoundedCornerView.layer.shadowOpacity = 0.5
//            whiteRoundedCornerView.tag = 1001 // Add a tag to identify the custom view
//
//            // Add the whiteRoundedCornerView to the cell's content view
//            cell.contentView.addSubview(whiteRoundedCornerView)
//            cell.contentView.sendSubviewToBack(whiteRoundedCornerView)
//
//            // Add extra spacing at the bottom of each cell except the last one
//            if indexPath.row < tableView.numberOfRows(inSection: indexPath.section) - 1 {
//                let spacerView = UIView(frame: CGRect(x: 0, y: cell.contentView.frame.height - 10, width: cell.contentView.frame.width, height: 30))
//                spacerView.backgroundColor = UIColor.clear
//                spacerView.tag = 1002
//                cell.contentView.addSubview(spacerView)
//            }
//        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getproductId(index: indexPath.row)
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
         navigationController?.pushViewController(brandsViewController, animated: true)
    }

    
}
