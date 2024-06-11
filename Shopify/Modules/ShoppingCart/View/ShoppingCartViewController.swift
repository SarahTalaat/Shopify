//
//  ShoppingCartViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CartTableViewCellDelegate{
   
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shoppingCartTableView: UITableView!
    
    let draftOrderService = DraftOrderNetworkService()
       var draftOrder: DraftOrder?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
           shoppingCartTableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")
           
           shoppingCartTableView.delegate = self
           shoppingCartTableView.dataSource = self
           
           self.title = "Shopping Cart"
           shoppingCartTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
           shoppingCartTableView.rowHeight = 100
           shoppingCartTableView.sectionHeaderHeight = 16
           
           fetchDraftOrders()
       }
       
       func fetchDraftOrders() {
           draftOrderService.fetchDraftOrders { [weak self] result in
               switch result {
               case .success(let draftOrder):
                   self?.draftOrder = draftOrder
                   DispatchQueue.main.async {
                       self?.shoppingCartTableView.reloadData()
                       self?.updateTotalAmount()
                   }
               case .failure(let error):
                   print("Failed to fetch draft orders: \(error.localizedDescription)")
               }
           }
       }
       
       func updateTotalAmount() {
           guard let draftOrder = draftOrder else { return }
           totalAmount.text = draftOrder.subtotal_price
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return draftOrder == nil ? 0 : 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return draftOrder?.line_items.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
           if let lineItem = draftOrder?.line_items[indexPath.row] {
               let productName = lineItem.title.split(separator: "|").last?.trimmingCharacters(in: .whitespaces) ?? ""
                       cell.productName.text = productName
               let productColor = lineItem.variant_title.split(separator: "/").last?.trimmingCharacters(in: .whitespaces) ?? ""
               cell.productColor.text = productColor
               cell.productAmount.text = "\(lineItem.quantity)"
            
               cell.productPrice.text = "\(lineItem.price)$"
               cell.delegate = self
           }
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
           footerView.backgroundColor = .clear
           return footerView
       }
    
    @IBAction func processedToPaymentBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Third", bundle: nil)
        let addressVC = sb.instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
        navigationController?.pushViewController(addressVC, animated: true)
    }

    func didTapPlusButton(on cell: CartTableViewCell) {
            guard let indexPath = shoppingCartTableView.indexPath(for: cell),
                  var lineItem = draftOrder?.line_items[indexPath.row] else { return }
            
            lineItem.quantity += 1
            draftOrder?.line_items[indexPath.row] = lineItem
            updateTotalAmount()
            shoppingCartTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        func didTapMinusButton(on cell: CartTableViewCell) {
            guard let indexPath = shoppingCartTableView.indexPath(for: cell),
                  var lineItem = draftOrder?.line_items[indexPath.row] else { return }
            
            if lineItem.quantity > 1 {
                lineItem.quantity -= 1
                draftOrder?.line_items[indexPath.row] = lineItem
                updateTotalAmount()
                shoppingCartTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    func didTapDeleteButton(on cell: CartTableViewCell) {
            guard let indexPath = shoppingCartTableView.indexPath(for: cell),
                  var draftOrder = draftOrder else { return }
            
            draftOrder.line_items.remove(at: indexPath.row)
            
            draftOrderService.updateDraftOrder(draftOrder: draftOrder) { [weak self] result in
                switch result {
                case .success(let updatedDraftOrder):
                    self?.draftOrder = updatedDraftOrder
                    DispatchQueue.main.async {
                        self?.shoppingCartTableView.reloadData()
                        self?.updateTotalAmount()
                    }
                case .failure(let error):
                    print("Failed to update draft order: \(error.localizedDescription)")
                }
            }
        }
}
