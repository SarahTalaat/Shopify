//
//  ShoppingCartViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func processedToPaymentBtn(_ sender: UIButton) {
        let paymentVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
     
        paymentVC!.modalPresentationStyle = .fullScreen
       present(paymentVC!, animated: true, completion: nil)
    }
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shoppingCartTableView: UITableView!
    
}
