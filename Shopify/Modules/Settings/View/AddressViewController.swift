//
//  AddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class AddressViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    
    

    @IBAction func addNewAddress(_ sender: UIButton) {

    }
    @IBOutlet weak var addressTableView: UITableView!
    override func viewDidLoad() {
            super.viewDidLoad()
            
            let nib = UINib(nibName: "addressTableViewCell", bundle: nil)
            addressTableView.register(nib, forCellReuseIdentifier: "addressTableViewCell")
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: addressTableView.frame.width, height: 40))
            headerView.backgroundColor = .clear
            addressTableView.tableHeaderView = headerView
            
            addressTableView.delegate = self
            addressTableView.dataSource = self
            addressTableView.separatorStyle = .none
            addressTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            addressTableView.reloadData()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as! addressTableViewCell
            
            cell.userName.text = "User \(indexPath.row + 1)"
            cell.addressDetails.text = "Address details for user \(indexPath.row + 1)"
            
            return cell
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 20
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }
    }


