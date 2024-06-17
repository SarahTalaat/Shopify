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
        viewModel.isDataBound = true
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
    var isFavourite: Bool? = false
    
    var viewModel: ProductDetailsViewModelProtocol!
    var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = DependencyProvider.productDetailsViewModel
      //  addActivityIndicator()
        viewModel.getProduct()
        bindViewModel()
        setUpFavouriteButton()

        
        priceLabel.text = viewModel.customProductDetails?.price
        
        print("PD View viewdidload: \(viewModel.customProductDetails?.price) ")
        brandNameLabel.text = viewModel.customProductDetails?.vendor
        brandTitleLabel.text = viewModel.customProductDetails?.title
        descriptionLabel.text = viewModel.customProductDetails?.description
        
    
//        let imageName = isFavourite ? "heart.fill" : "heart"
//        let image = UIImage(systemName: imageName)
//        favouriteButton.setImage(image, for: .normal)
        
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

        updateFavoriteUI(isFavorite: viewModel.isFavourite ?? false)
    }
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func bindViewModel() {
     //   activityIndicator.startAnimating()
        viewModel.bindCustomProductDetailsViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.favoriteStateDidChange = { [weak self] isFavorite in
            self?.updateFavoriteUI(isFavorite: isFavorite)
        }
    }
    
    func updateFavoriteUI(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favouriteButton.setImage(image, for: .normal)
        favouriteButton.adjustsImageWhenHighlighted = false
    }
    func updateUI() {
    //    activityIndicator.stopAnimating()
        // Update UI elements with fetched data
        priceLabel.text = viewModel.customProductDetails?.price
        brandNameLabel.text = viewModel.customProductDetails?.vendor
        brandTitleLabel.text = viewModel.customProductDetails?.title
        descriptionLabel.text = viewModel.customProductDetails?.description
        print("PD View updateUI price: \(viewModel.customProductDetails?.price) ")
        myCollectionView.reloadData() // Reload collection view if data for images has changed
        
        // Example: You may need to update dropdowns too
        dropDowntableView1.reloadData()
        dropDowntableView2.reloadData()
    }
    
    func applyRoundedBorders(to textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.masksToBounds = true
    }



    @IBAction func favouriteButtonTapped(_ sender: UIButton) {

        viewModel.toggleFavorite()
        
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
            return viewModel.customProductDetails?.colour?.count ?? 1
        case dropDowntableView2:
            return viewModel.customProductDetails?.size?.count ?? 1
        default:
            return viewModel.customProductDetails?.size?.count ?? 1
        }
        
  // or dropdownItems2.count depending on the tableView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == dropDowntableView1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell1", for: indexPath)
            
            if(indexPath.row < viewModel.customProductDetails?.size?.count ?? 1){
                cell.textLabel?.text = viewModel.customProductDetails?.size?[indexPath.row]
            }

        } else if tableView == dropDowntableView2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell2", for: indexPath)
            
            
            if(indexPath.row < viewModel.customProductDetails?.colour?.count ?? 1){
                cell.textLabel?.text = viewModel.customProductDetails?.colour?[indexPath.row] ?? "Red"
            }

        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("didSelectRowAt called")
        if tableView == dropDowntableView1 {
            dropdownButton.setTitle(viewModel.customProductDetails?.size?[indexPath.row], for: .normal)
            isDropdownVisible = false
            dropDowntableView1.isHidden = true
        } else if tableView == dropDowntableView2 {
            dropdownButton2.setTitle(viewModel.customProductDetails?.colour?[indexPath.row], for: .normal)
            isDropdownVisible2 = false
            dropDowntableView2.isHidden = true
        }
    }



    

    func settingUpCollectionView(){
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        myCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.customProductDetails?.images?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        if let imageUrlString = viewModel.customProductDetails?.images?[indexPath.row],
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




