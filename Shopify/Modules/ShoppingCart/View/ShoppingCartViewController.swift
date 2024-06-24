//
//  ShoppingCartViewController.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 02/06/2024.
//

import UIKit
import Kingfisher
class ShoppingCartViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate{
  

    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var shoppingCartTableView: UITableView!

    let draftOrderService = DraftOrderNetworkService()

    var draftOrder: DraftOrderPUT?
    private let viewModel = ShoppingCartViewModel()
             
   
          
       override func viewDidLoad() {
           super.viewDidLoad()
              
           viewModel.getUserDraftOrderId()
           
           let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
           shoppingCartTableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")
              
           shoppingCartTableView.delegate = self
           shoppingCartTableView.dataSource = self
              
           self.title = "Shopping Cart"
           shoppingCartTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
           shoppingCartTableView.rowHeight = 100
           shoppingCartTableView.sectionHeaderHeight = 16
              
           bindViewModel()
       //    viewModel.fetchDraftOrders()
           print("Total amount before navigating to PaymentVC: \(viewModel.totalAmount)")
//           shoppingCartTableView.layer.cornerRadius = 8.0
//               shoppingCartTableView.layer.borderWidth = 1.0
//               shoppingCartTableView.layer.borderColor = UIColor.lightGray.cgColor
//               shoppingCartTableView.layer.masksToBounds = true
           addBottomBorder(to: shoppingCartTableView)
       }
         
    func addBottomBorder(to tableView: UITableView) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.lightGray // Set the border color
        
        tableView.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 1), // Set the border height
            border.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            border.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
      private func bindViewModel() {
          viewModel.onDraftOrderUpdated = { [weak self] in
              DispatchQueue.main.async {
                  self?.shoppingCartTableView.reloadData()
              }
          }

          viewModel.onTotalAmountUpdated = { [weak self] in
                  DispatchQueue.main.async {
                      self?.totalAmount.text = self?.viewModel.formatPriceWithCurrency(price: self?.viewModel.totalAmount ?? "")
                      if let paymentVC = self?.navigationController?.viewControllers.last as? PaymentViewController {
                          paymentVC.totalAmount = self?.viewModel.totalAmount
                      }
                  }
              
          }

          viewModel.onAlertMessage = { [weak self] message in
              DispatchQueue.main.async {
                  self?.showAlert(message: message)
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
                  cell.productPrice.text = viewModel.formatPriceWithCurrency(price: lineItem.price)

                  draftOrderService.fetchProduct(productId: lineItem.productId ?? 0) { result in
                      switch result {
                      case .success(let product):
                          let imageUrl = product.image.src
                          if let url = URL(string: imageUrl) {
                              DispatchQueue.main.async {
                                  cell.productimage.kf.setImage(with: url)
                              }
                          }
                      case .failure(let error):
                          print("Failed to fetch product image: \(error.localizedDescription)")
                      }
                  }

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
                 paymentVC.totalAmount = totalAmount.text // Directly use the updated amount
                 if let firstLineItem = viewModel.draftOrder?.draftOrder?.lineItems {
                     paymentVC.lineItems = firstLineItem
                 }
                 navigationController?.pushViewController(paymentVC, animated: true)
             }
       }
    func didTapPlusButton(on cell: CartTableViewCell) {
        guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }
        viewModel.incrementQuantity(at: indexPath.row)

        shoppingCartTableView.reloadData()
    }

    func didTapMinusButton(on cell: CartTableViewCell) {
        guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }
        let currentQuantity = viewModel.draftOrder?.draftOrder?.lineItems[indexPath.row].quantity ?? 0

        if currentQuantity == 1 {
            let alert = UIAlertController(title: "Delete Item", message: "You will delete this item. Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.viewModel.decrementQuantity(at: indexPath.row)
                self.viewModel.deleteItem(at: indexPath.row)
                self.shoppingCartTableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateTotalAmount()
                self.viewModel.saveChanges()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            viewModel.decrementQuantity(at: indexPath.row)
            shoppingCartTableView.reloadRows(at: [indexPath], with: .none)
            updateTotalAmount()
            viewModel.saveChanges()
        }
    }

    func didTapDeleteButton(on cell: CartTableViewCell) {
        guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel.deleteItem(at: indexPath.row)
            self.shoppingCartTableView.reloadData()
            self.updateTotalAmount()
        }))
        present(alert, animated: true, completion: nil)
    }
    private func updateTotalAmount() {
        viewModel.updateTotalAmount()
        totalAmount.text = viewModel.formatPriceWithCurrency(price: viewModel.totalAmount)
    }
    @IBAction func addCouponBtn(_ sender: UIButton) {
        let couponVC = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
            couponVC.subtotal = viewModel.totalAmount
            couponVC.delegate = self
        if let sheet = couponVC.sheetPresentationController{
                   sheet.detents = [.medium()]
                   sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                   sheet.preferredCornerRadius = 40
                   
               }
         
              present(couponVC, animated: true, completion: nil)
        print("ssssss")
    }
    
    @IBOutlet weak var couponView: UIView!
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}

extension ShoppingCartViewController: CouponViewControllerDelegate {
    func updateTotalAmount(with amount: String) {
        viewModel.totalAmount = amount
        totalAmount.text = viewModel.formatPriceWithCurrency(price: amount)
        updatePaymentViewControllerTotalAmount(with: amount)
    }

    func updateGrandTotal(with amount: String) {
        totalAmount.text = amount
    }

    func updateGrandTotalFromCoupon(with amount: String) {
        totalAmount.text = amount
    }
    
    private func updatePaymentViewControllerTotalAmount(with amount: String) {
        if let paymentVC = navigationController?.viewControllers.first(where: { $0 is PaymentViewController }) as? PaymentViewController {
            paymentVC.totalAmount = amount
            paymentVC.updateGrandTotal(with: amount) // Ensure this method updates the UI in PaymentViewController
        }
    }
}
