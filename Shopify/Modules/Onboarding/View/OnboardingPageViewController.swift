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
    @IBOutlet weak var actionButton: UIButton!

    var imageName: String?
    var titleText: String?
    var descriptionText: String?
    var buttonText: String?

    
    // MARK: - Lifecycle
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {

        if buttonText == "Get Started" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
                  if let signUpVC = sb.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
                      let navController = UINavigationController(rootViewController: signUpVC)
                      navController.modalPresentationStyle = .fullScreen
                      present(navController, animated: true, completion: nil)
              }
          } else {
              if let scrollView = view.superview as? UIScrollView {
                  let nextOffset = scrollView.contentOffset.x + scrollView.frame.width
                  scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
              }
          }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to white
        view.backgroundColor = .white
        
        // Set the content for the views
        myImage.image = UIImage(named: imageName ?? "")
       myImage.contentMode = .redraw
        myTitle.text = titleText
        myDescription.text = descriptionText
        actionButton.setTitle(buttonText, for: .normal)
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
