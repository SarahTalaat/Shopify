//
//  ShoppingCartViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
          super.viewDidLoad()

      
          let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
          shoppingCartTableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")

      
          shoppingCartTableView.delegate = self
          shoppingCartTableView.dataSource = self

          
          shoppingCartTableView.reloadData()
        self.title = "Shopping Cart"
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
          
          // Configure the cell
          cell.productName.text = "Product \(indexPath.row + 1)"
          cell.productPrice.text = "$\(10 * (indexPath.row + 1))"
         
        
        
          
          return cell
      }
    

    
    @IBAction func processedToPaymentBtn(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Third", bundle: nil)
        let paymentVC = sb.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentViewController
        navigationController?.pushViewController(paymentVC, animated: true)
     
    }
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shoppingCartTableView: UITableView!
    
}
