//
//  CategoryViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 01/06/2024.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var shoesBtn: UIButton!
    
    @IBOutlet weak var bagsBtn: UIButton!
    
    @IBOutlet weak var clothBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var shoesButtonCenter: CGPoint!
    var bagsButtonCenter: CGPoint!
    var clothButtonCenter: CGPoint!
    var isButtonMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoesButtonCenter = shoesBtn.center
        bagsButtonCenter = bagsBtn.center
        clothButtonCenter = clothBtn.center

        shoesBtn.center = allBtn.center
        bagsBtn.center = allBtn.center
        clothBtn.center = allBtn.center

        shoesBtn.alpha = 0
        bagsBtn.alpha = 0
        clothBtn.alpha = 0

        
        shoesBtn.applyShadow()
        bagsBtn.applyShadow()
        clothBtn.applyShadow()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didClickMoreButton(_ sender: UIButton) {
        if isButtonMenuOpen {UIView.animate(withDuration: 0.3) {
            self.shoesBtn.center = self.allBtn.center
            self.bagsBtn.center = self.allBtn.center
            self.clothBtn.center = self.allBtn.center

            
            self.shoesBtn.alpha = 0
            self.bagsBtn.alpha = 0
            self.clothBtn.alpha = 0

        }
                self.isButtonMenuOpen = false
            
        } else {
            UIView.animate(withDuration: 0.3){
                self.shoesBtn.center = self.shoesButtonCenter
                self.bagsBtn.center = self.bagsButtonCenter
                self.clothBtn.center = self.clothButtonCenter

                self.shoesBtn.alpha = 1
                self.bagsBtn.alpha = 1
                self.clothBtn.alpha = 1

            }
                self.isButtonMenuOpen = true
            }
        }
    
}

extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.productBrand.text = "Zara"
        cell.productPrice.text = "9$"
        cell.productName.text = "Black Dress"
        return cell
    }
}
    

extension UIButton {
    func applyShadow() {
    layer.shadowOpacity = 0.6
 }
}
