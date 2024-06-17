//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Sara Talat on 03/06/2024.
//

import UIKit
import Kingfisher

class ProductDetailsVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UITableViewDelegate , UITableViewDataSource{

    @IBAction func addToCartButton(_ sender: CustomButton) {
        viewModel.addToCart()
        
    }
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var brandTitleLabel: UILabel!
    
    @IBOutlet weak var reviewTextView2: UITextView!
    @IBOutlet weak var reviewTextView1: UITextView!

    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet var myCollectionView: UICollectionView!
    var imageArray: [String] = ["image.png","image.png","image.png","image.png","image.png"]
    @IBOutlet var dropdownButton2: UIButton!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropDowntableView1: UITableView!
    @IBOutlet weak var dropDowntableView2: UITableView!
    var cell: UITableViewCell!
    var reviewCell: CustomReviewsTableViewCell!
    var sizeArray: [String] = ["Option 1", "Option 2", "Option 3", "Option 4"]
    var colourArray: [String] = ["Item1","Item2","Item3","Item4","Item5"]
    var isDropdownVisible = false
    var isDropdownVisible2 = false
    var isFavourite = false
    
    var viewModel: ProductDetailsViewModelProtocol!
    var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = DependencyProvider.productDetailsViewModel
        bindViewModel()
        viewModel.getProductDetails()
        
        settingUpCollectionView()

        settingUpDropdown(dropDowntableView: dropDowntableView1, cellIdentifier: "dropdownCell1")
        settingUpDropdown(dropDowntableView: dropDowntableView2, cellIdentifier: "dropdownCell2")
        setupDropdownButton(dropdownButton: dropdownButton, buttonTitle: "Size", imageName: "chevron.down")
        setupDropdownButton(dropdownButton: dropdownButton2, buttonTitle: "Colour", imageName: "chevron.down")
        setupDropdownTableView1(dropDowntableView: dropDowntableView1)
        setupDropdownTableView1(dropDowntableView: dropDowntableView2)
        
        setUpFavouriteButton()
        
        applyRoundedBorders(to: reviewTextView1)
        applyRoundedBorders(to: reviewTextView2)
        applyRoundedBorders(to: descriptionLabel)


    }
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    

    
    func applyRoundedBorders(to textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.masksToBounds = true
    }



    @IBAction func favouriteButtonTapped(_ sender: UIButton) {

        // Toggle the state
        isFavourite.toggle()
        
        // Set the image for the button based on the state
        let imageName = isFavourite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        sender.setImage(image, for: .normal)
        
        // Disable the button's adjustment when highlighted to remove the blue shadow
        sender.adjustsImageWhenHighlighted = false
        
        
        if isFavourite {
            viewModel.addProductToFirebase()
        }else{
            viewModel.deleteProductFromFirebase()
        }
        
    }
    func setUpFavouriteButton(){
        // Make the button circular
        favouriteButton.layer.cornerRadius = favouriteButton.bounds.width / 2

        // Set background color
        favouriteButton.backgroundColor = .white

        // Apply shadow to the button
        favouriteButton.layer.shadowColor = UIColor.gray.cgColor
        favouriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favouriteButton.layer.shadowOpacity = 0.5
        favouriteButton.layer.shadowRadius = 4

        // Ensure that shadow is not clipped
        favouriteButton.layer.masksToBounds = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Check if dropdown table view 1 is visible, if yes, hide it
        if isDropdownVisible {
            isDropdownVisible = false
            dropDowntableView1.isHidden = true
        }
        
        // Check if dropdown table view 2 is visible, if yes, hide it
        if isDropdownVisible2 {
            isDropdownVisible2 = false
            dropDowntableView2.isHidden = true
        }
    }
    
    // Your existing table view delegate methods


    func settingUpDropdown(dropDowntableView: UITableView , cellIdentifier: String) {
        dropDowntableView.isHidden = true
        dropDowntableView.delegate = self
        dropDowntableView.dataSource = self
        dropDowntableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(cellIdentifier)")
    }
    //chevron.down
    
    func setupDropdownButton(dropdownButton: UIButton, buttonTitle: String , imageName: String) {
        dropdownButton.layer.borderWidth = 2.0
        dropdownButton.layer.borderColor = UIColor.orange.cgColor
        dropdownButton.layer.cornerRadius = 10
        dropdownButton.contentHorizontalAlignment = .left
        dropdownButton.setTitle("  \(buttonTitle)        ", for: .normal)

        dropdownButton.setImage(UIImage(systemName: "\(imageName)"), for: .normal)
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.titleLabel?.adjustsFontForContentSizeCategory = true

    }

    func bindViewModel() {
        viewModel.bindProductDetailsViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                self?.myCollectionView.reloadData()
                self?.dropDowntableView1.reloadData()
                self?.dropDowntableView2.reloadData()
            }
        }
    }
    
    func setupDropdownTableView1(dropDowntableView: UITableView) {
        dropDowntableView.layer.borderWidth = 1.0
        dropDowntableView.layer.borderColor = UIColor.orange.cgColor
        dropDowntableView.layer.cornerRadius = 5.0
        dropDowntableView.backgroundColor = .white
        
    }
    
    @IBAction func dropdownButtopTapped2(_ sender: UIButton) {
        isDropdownVisible2.toggle()
        dropDowntableView2.isHidden = !isDropdownVisible2
 
    }
    
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        isDropdownVisible.toggle()
        dropDowntableView1.isHidden = !isDropdownVisible

       
    }

        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(tableView){
        case dropDowntableView1:
          //color
            return viewModel.getSizeCount()
        case dropDowntableView2:
          //size
            return viewModel.getColoursCount()
        default:
          //size
            return viewModel.getSizeCount()
            
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == dropDowntableView1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell1", for: indexPath)
            
            if(indexPath.row < viewModel.getSizeCount()){
                cell.textLabel?.text = viewModel.getColour(index: indexPath.row)
            }

        } else if tableView == dropDowntableView2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell2", for: indexPath)
            
            
            if(indexPath.row < viewModel.getColoursCount()){
                cell.textLabel?.text = viewModel.getsize(index: indexPath.row)
            }

        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("didSelectRowAt called")
        if tableView == dropDowntableView1 {
            dropdownButton.setTitle(viewModel.getsize(index: indexPath.row), for: .normal)
            isDropdownVisible = false
            dropDowntableView1.isHidden = true
        } else if tableView == dropDowntableView2 {
            dropdownButton2.setTitle(viewModel.getColour(index: indexPath.row), for: .normal)
            isDropdownVisible2 = false
            dropDowntableView2.isHidden = true
        }
    }

    

    func settingUpCollectionView(){
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        myCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.product?.product?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        if let imageUrlString = viewModel.product?.product?.images?[indexPath.row].src,
           let imageUrl = URL(string: imageUrlString) {
            cell.productImage.kf.setImage(with: imageUrl)
        } else {
            cell.productImage.image = UIImage(named: "loading.png")
        }
    
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




