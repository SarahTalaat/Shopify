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
    @IBOutlet var dropdownButton2: UIButton!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropDowntableView1: UITableView!
    @IBOutlet weak var dropDowntableView2: UITableView!
    var cell: UITableViewCell!
    var dropdownItems: [String] = ["Option 1", "Option 2", "Option 3", "Option 4"]
    var dropdownItems2: [String] = ["Item1","Item2","Item3","Item4","Item5"]
    var isDropdownVisible = false
    var isDropdownVisible2 = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        settingUpCollectionView()
//        settingUpDropdown()
//        setupDropdownButton1()
//        setupDropdownTableView1()
        settingUpCollectionView()
        settingUpDropdown(dropDowntableView: dropDowntableView1, cellIdentifier: "dropdownCell1")
        settingUpDropdown(dropDowntableView: dropDowntableView2, cellIdentifier: "dropdownCell2")
        setupDropdownButton1(dropdownButton: dropdownButton, buttonTitle: "Option", imageName: "chevron.down")
        setupDropdownButton1(dropdownButton: dropdownButton2, buttonTitle: "Item", imageName: "chevron.down")
        setupDropdownTableView1(dropDowntableView: dropDowntableView1)
        setupDropdownTableView1(dropDowntableView: dropDowntableView2)


        // Do any additional setup after loading the view.
    }
    
    
    
    
    func settingUpDropdown(dropDowntableView: UITableView , cellIdentifier: String) {
        dropDowntableView.isHidden = true
        dropDowntableView.delegate = self
        dropDowntableView.dataSource = self
        dropDowntableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(cellIdentifier)")
    }
    //chevron.down
    
    func setupDropdownButton1(dropdownButton: UIButton, buttonTitle: String , imageName: String) {
        dropdownButton.layer.borderWidth = 2.0
        dropdownButton.layer.borderColor = UIColor.orange.cgColor
        dropdownButton.layer.cornerRadius = 10
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.setTitle("  \(buttonTitle)        ", for: .normal)
        dropdownButton.setImage(UIImage(systemName: "\(imageName)"), for: .normal)
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.titleLabel?.adjustsFontForContentSizeCategory = true

    }
    
    func setupDropdownTableView1(dropDowntableView: UITableView) {
        dropDowntableView.layer.borderWidth = 1.0
        dropDowntableView.layer.borderColor = UIColor.orange.cgColor
        dropDowntableView.layer.cornerRadius = 5.0
    }
    
    @IBAction func dropdownButtopTapped2(_ sender: UIButton) {
        isDropdownVisible2.toggle()
        dropDowntableView2.isHidden = !isDropdownVisible2
    }
    
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        isDropdownVisible.toggle()
        dropDowntableView1.isHidden = !isDropdownVisible
       
    }

    
    
//       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           return dropdownItems.count
//       }
//
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell = dropDowntableView1.dequeueReusableCell(withIdentifier: "dropdownCell1", for: indexPath)
//           cell.textLabel?.text = dropdownItems[indexPath.row]
//           return cell
//       }
//
//
//       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           dropdownButton.setTitle(dropdownItems[indexPath.row], for: .normal)
//           isDropdownVisible = false
//           dropDowntableView1.isHidden = true
//       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownItems.count // or dropdownItems2.count depending on the tableView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == dropDowntableView1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell1", for: indexPath)
            cell.textLabel?.text = dropdownItems[indexPath.row]
        } else if tableView == dropDowntableView2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell2", for: indexPath)
            cell.textLabel?.text = dropdownItems2[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropDowntableView1 {
            dropdownButton.setTitle(dropdownItems[indexPath.row], for: .normal)
            isDropdownVisible = false
            dropDowntableView1.isHidden = true
        } else if tableView == dropDowntableView2 {
            dropdownButton2.setTitle(dropdownItems2[indexPath.row], for: .normal)
            isDropdownVisible2 = false
            dropDowntableView2.isHidden = true
        }
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




