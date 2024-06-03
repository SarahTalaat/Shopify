//
//  SignInVC.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var emailCustomTextField: CustomTextField!
    @IBOutlet var passwordCustomTextField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSignInScreenUI()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            // If you want to set it as the root view controller
            UIApplication.shared.windows.first?.rootViewController = tabBarController
        }
    }
    
    
    func navToHome(){
        let sb = UIStoryboard(name: "Second", bundle: nil)
        let homeVC = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    
    func setUpSignInScreenUI() {

        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Ensure the button's corners are rounded
        CustomButton.buttonRoundedCorner(button: signInButton)
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

