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
    
    
    func setUpSignInScreenUI() {

        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Ensure the button's corners are rounded
        CustomTextField.buttonRoundedCorner(button: signInButton)
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
