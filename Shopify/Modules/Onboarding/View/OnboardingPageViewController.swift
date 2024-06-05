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
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {

        // Inside the view controller you want to dismiss from
        dismiss(animated: true, completion: nil)
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let signUpVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
        navigationController?.pushViewController(signUpVC, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to white
        view.backgroundColor = .white
        
        // Set the content for the views
        myImage.image = UIImage(named: imageName ?? "")
        myTitle.text = titleText
        myDescription.text = descriptionText
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make the image view circular
        myImage.contentMode = .scaleAspectFill
        myImage.frame = CGRect(x: myImage.frame.origin.x, y: myImage.frame.origin.y, width: 306, height: 306)
        myImage.layer.cornerRadius = myImage.frame.height / 2
        myImage.clipsToBounds = true
        
    }
    
}
