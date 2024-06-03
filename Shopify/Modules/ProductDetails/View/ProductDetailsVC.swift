//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Sara Talat on 03/06/2024.
//

import UIKit

class ProductDetailsVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UITableViewDelegate , UITableViewDataSource{

    
    @IBOutlet var myCollectionView: UICollectionView!
    var imageArray: [String] = ["a.jpg","b.jpg","c.jpg","d.jpg","e.jpg"]
    
    
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropDowntableView1: UITableView!
    
    var dropdownItems: [String] = ["Option 1", "Option 2", "Option 3", "Option 4"]
    var isDropdownVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingUpCollectionView()
        settingUpDropdown()
        setupDropdownButton1()
        setupDropdownTableView1()


        // Do any additional setup after loading the view.
    }
    
    
    func settingUpDropdown() {
        dropDowntableView1.isHidden = true
        dropDowntableView1.delegate = self
        dropDowntableView1.dataSource = self
        dropDowntableView1.register(UITableViewCell.self, forCellReuseIdentifier: "dropdownCell1")
    }
    
    func setupDropdownButton1() {
        dropdownButton.layer.borderWidth = 1.0
        dropdownButton.layer.borderColor = UIColor.gray.cgColor
        dropdownButton.layer.cornerRadius = 5.0
    }
    
    func setupDropdownTableView1() {
        dropDowntableView1.layer.borderWidth = 1.0
        dropDowntableView1.layer.borderColor = UIColor.gray.cgColor
        dropDowntableView1.layer.cornerRadius = 5.0
    }
    
    
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        isDropdownVisible.toggle()
        dropDowntableView1.isHidden = !isDropdownVisible
    }
    
    
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dropdownItems.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = dropDowntableView1.dequeueReusableCell(withIdentifier: "dropdownCell1", for: indexPath)
           cell.textLabel?.text = dropdownItems[indexPath.row]
           return cell
       }

       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           dropdownButton.setTitle(dropdownItems[indexPath.row], for: .normal)
           isDropdownVisible = false
           dropDowntableView1.isHidden = true
       }
    

    func settingUpCollectionView(){
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        myCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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




