//
//  AddressViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class AddressViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as! addressTableViewCell
        
        return cell
    }
    

    @IBAction func addNewAddress(_ sender: UIButton) {
        let newAddressVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "NewAddressViewController") as? NewAddressViewController
     
        newAddressVC!.modalPresentationStyle = .fullScreen
       present(newAddressVC!, animated: true, completion: nil)
    }
    @IBOutlet weak var addressTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

   

}
