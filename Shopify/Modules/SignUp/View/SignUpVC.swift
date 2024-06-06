//
//  SignUpVC.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet var passwordCustomTextField: CustomTextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var alreadySignedInCustomButton: UIButton!
    @IBOutlet var emailCustomTextField: CustomTextField!
    @IBOutlet var nameCustomTextField: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSignUpScreenUI()
        makeCircularImage()

    }
    
    
    @IBAction func alreadyHaveAnAccountButtonTapped(_ sender: UIButton) {
        navToSignIn()
        
    }
    
    func makeCircularImage() {
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
        logoImage.clipsToBounds = true
    }
    @IBAction func signUpButton(_ sender: UIButton) {
        
        navToSignIn()
        
    }
    @IBAction func continueAsAGuestButtonTapped(_ sender: UIButton) {
        
        navToHome()
    }
    
    func navToHome(){
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            // If you want to set it as the root view controller
            UIApplication.shared.windows.first?.rootViewController = tabBarController
        }
    }
    
    func navToSignIn(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Ensure the button's corners are rounded
        CustomButton.buttonRoundedCorner(button: signUpButton)
    }
    
    func setUpSignUpScreenUI(){
        CustomTextField.customTextFieldUI(customTextField: nameCustomTextField, label: "Name : ")
        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
        CustomButton.buttonImageColor(button: alreadySignedInCustomButton)
        CustomButton.buttonShadow(button: signUpButton)
        CustomButton.setupButtonTitle(alreadySignedInCustomButton)
        CustomButton.setupButtonTitle(signUpButton)
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
