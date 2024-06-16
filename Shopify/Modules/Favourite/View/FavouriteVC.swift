//
//  FavouriteVC.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class FavouriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var favouriteTableView: UITableView!
    let backButton = UIBarButtonItem()
    var window: UIWindow?
    let cellSpacingHeight: CGFloat = 30
    
    var viewModel: FavouriteViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUpFavouriteTableView()
        viewModel = DependencyProvider.favouriteViewModel
        
        viewModel.retriveProducts()
        
        favouriteTableView.reloadData()
        
    }

    
    func settingUpFavouriteTableView(){
        // Register the custom cell
        let nib = UINib(nibName: "FavouritesCustomCell", bundle: nil)
        favouriteTableView.register(nib, forCellReuseIdentifier: "cell")

        favouriteTableView.dataSource = self
        favouriteTableView.delegate = self
        
        // Set table view properties
        favouriteTableView.separatorStyle = .none // Remove default separators
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
        

        cell.productSize.text = viewModel.products?[indexPath.row].productVendor
        cell.productType.text = "Shirt"
        

        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    // Set the height for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Reset the background color for every cell
            cell.contentView.backgroundColor = UIColor.systemGray6
            
            // Remove existing custom views if any (to avoid multiple overlays)
            for subview in cell.contentView.subviews where subview.tag == 1001 || subview.tag == 1002 {
                subview.removeFromSuperview()
            }
            
            // Add the custom white rounded corner view
            let whiteRoundedCornerView = UIView(frame: CGRect(x: 10, y: 10, width: cell.contentView.frame.width - 20, height: cell.contentView.frame.height - 40))
            whiteRoundedCornerView.backgroundColor = UIColor.white
            whiteRoundedCornerView.layer.masksToBounds = false
            whiteRoundedCornerView.layer.cornerRadius = 10
            whiteRoundedCornerView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedCornerView.layer.shadowOpacity = 0.5
            whiteRoundedCornerView.tag = 1001 // Add a tag to identify the custom view

            // Add the whiteRoundedCornerView to the cell's content view
            cell.contentView.addSubview(whiteRoundedCornerView)
            cell.contentView.sendSubviewToBack(whiteRoundedCornerView)
            
            // Add extra spacing at the bottom of each cell except the last one
            if indexPath.row < tableView.numberOfRows(inSection: indexPath.section) - 1 {
                let spacerView = UIView(frame: CGRect(x: 0, y: cell.contentView.frame.height - 10, width: cell.contentView.frame.width, height: 30))
                spacerView.backgroundColor = UIColor.clear
                spacerView.tag = 1002
                cell.contentView.addSubview(spacerView)
            }
        }

    
}
