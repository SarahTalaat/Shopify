//
//  OnboardingPageViewController.swift
//  Shopify
//
//  Created by Sara Talat on 05/06/2024.
//
import UIKit

class OnboardingPageViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myDescription: UILabel!
    
    var imageName: String?
    var titleText: String?
    var descriptionText: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to white
        view.backgroundColor = .white
        
        // Set the content for the views
        myImage.image = UIImage(named: imageName ?? "")
        myTitle.text = titleText
        myDescription.text = descriptionText
        
        myImage.layer.cornerRadius = myImage.frame.width / 2
        myImage.clipsToBounds = true
        
    }
}
