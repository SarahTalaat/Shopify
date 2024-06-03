//
//  HomeViewController.swift
//  Shopify
//
//  Created by Haneen Medhat on 31/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    @IBAction func favBtn(_ sender: UIBarButtonItem) {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //                 let brandsViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        //                 navigationController?.pushViewController(brandsViewController, animated: true)
    }
    
    
    @IBAction func cartBtn(_ sender: UIBarButtonItem) {
//        let storyboard = UIStoryboard(name: "Third", bundle: nil)
//                 let brandsViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//                 navigationController?.pushViewController(brandsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsCollectionView.collectionViewLayout = adsCollectionViewLayout()
        brandsCollectionView.collectionViewLayout = brandsCollectionViewLayout()
        // Do any additional setup after loading the view.
    }
    
    
    func adsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
    }
    
    func brandsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
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

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionViewCell", for: indexPath) as! AdsCollectionViewCell
            cell.adsImage.image = UIImage(named: "Sale.jpeg")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as! BrandsCollectionViewCell
            cell.brandImage.image = UIImage(named: "download.png")
            cell.brandLabel.text = "ADIDAS"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == adsCollectionView {
          printContent("Ads")
        } else {
            let storyboard = UIStoryboard(name: "Second", bundle: nil)
                     let brandsViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                     navigationController?.pushViewController(brandsViewController, animated: true)
                  }
        }
    }

