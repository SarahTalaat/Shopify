//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Sara Talat on 03/06/2024.
//

import UIKit

class ProductDetailsVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet var myCollectionView: UICollectionView!
    
    
    var imageArray: [String] = ["a.jpg","b.jpg","c.jpg","d.jpg","e.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        myCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)



        // Do any additional setup after loading the view.
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.productImage.image = UIImage(named: imageArray[indexPath.row])
    
     //   cell.productImage.layer.cornerRadius = 30
        
        return cell
    }
    

    }



    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */




