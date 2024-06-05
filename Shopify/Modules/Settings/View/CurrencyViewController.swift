//
//  CurrencyViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 01/06/2024.
//

import UIKit

class CurrencyViewController: UIViewController,UITableViewDelegate, UITableViewDataSource 
{
    let tableView = UITableView()
    let currency = ["USD", "EGP", "USA"]
    @IBOutlet weak var currencyTableView: UITableView!
  
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return currency.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        cell.currency.text = currency[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CurrencyTableViewCell", bundle: nil)
        currencyTableView.register(nib, forCellReuseIdentifier: "CurrencyTableViewCell")
        self.title = "Currency"
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.separatorStyle = .none
      
        currencyTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                view.addSubview(currencyTableView)
        currencyTableView.frame = view.bounds
        currencyTableView.reloadData()
    }
    
    @IBOutlet weak var USDView: UIView!
    
    
    @IBOutlet weak var EGPView: UIView!
    
}
