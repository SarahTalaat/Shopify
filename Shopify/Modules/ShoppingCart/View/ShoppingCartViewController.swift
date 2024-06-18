//
//  ShoppingCartViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate{
   
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shoppingCartTableView: UITableView!


    let draftOrderService = DraftOrderNetworkService()
       var draftOrder: DraftOrderPUT?
       

    
    private let viewModel = ShoppingCartViewModel()
           

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
           
           bindViewModel()
           viewModel.fetchDraftOrders()
       }
       
       private func bindViewModel() {
           viewModel.onDraftOrderUpdated = { [weak self] in
               DispatchQueue.main.async {
                   self?.shoppingCartTableView.reloadData()
               }
           }
           
           viewModel.onTotalAmountUpdated = { [weak self] in
               DispatchQueue.main.async {
                   self?.totalAmount.text = self?.viewModel.totalAmount
               }
           }
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return viewModel.draftOrder == nil ? 0 : 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.draftOrder?.draftOrder?.lineItems.count ?? 0
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        if let lineItem = viewModel.draftOrder?.draftOrder?.lineItems[indexPath.row] {
            let productName = lineItem.title.split(separator: "|").last?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            cell.productName.text = productName
            
            let productColor = lineItem.variantTitle?.split(separator: "/").last?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
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
           let storyboard = UIStoryboard(name: "Third", bundle: nil)
              if let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentViewController {
                  if let firstLineItem = viewModel.draftOrder?.draftOrder?.lineItems {
                      paymentVC.lineItems = firstLineItem
                  } else {
                      // Handle the case where draftOrder or line_items is nil
                  }
                  navigationController?.pushViewController(paymentVC, animated: true)
              }
       }

       func didTapPlusButton(on cell: CartTableViewCell) {
           guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }
           viewModel.incrementQuantity(at: indexPath.row)
       }
       
       func didTapMinusButton(on cell: CartTableViewCell) {
           guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }
           viewModel.decrementQuantity(at: indexPath.row)
       }
       
       func didTapDeleteButton(on cell: CartTableViewCell) {
           guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }
           viewModel.deleteItem(at: indexPath.row)
       }
    
}
