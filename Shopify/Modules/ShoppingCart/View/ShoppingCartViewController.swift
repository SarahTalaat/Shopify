//
//  ShoppingCartViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shoppingCartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        shoppingCartTableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        shoppingCartTableView.delegate = self
        shoppingCartTableView.dataSource = self
        
        shoppingCartTableView.reloadData()
        self.title = "Shopping Cart"
        shoppingCartTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        shoppingCartTableView.rowHeight = 100
        shoppingCartTableView.sectionHeaderHeight = 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear// Make the footer view transparent
        return footerView
    }
    
    @IBAction func processedToPaymentBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Third", bundle: nil)
        let paymentVC = sb.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentViewController
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
