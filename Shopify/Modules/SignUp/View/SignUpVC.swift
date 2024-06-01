//
//  SignUpVC.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet var passwordCustomTextField: CustomTextField!
    
    @IBOutlet var signUpButton: UIButton!
    

    @IBOutlet var alreadySignedInCustomButton: UIButton!
    @IBOutlet var emailCustomTextField: CustomTextField!
    @IBOutlet var nameCustomTextField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSignUpScreenUI()


    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Ensure the button's corners are rounded
        buttonRoundedCorner(button: signUpButton)
    }
    
    func setUpSignUpScreenUI(){
        customTextFieldUI(customTextField: nameCustomTextField, label: "Name : ")
        customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
        buttonImageColor(button: alreadySignedInCustomButton)
        buttonShadow(button: signUpButton)
    }
    
    
    func buttonRoundedCorner(button:UIButton){
        // Make sure the button's corners are rounded
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }
    
    func buttonShadow(button: UIButton){
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
    }
    
    
    func customTextFieldUI (customTextField : CustomTextField , label: String) {
        // Set the placeholder text
        customTextField.placeholder = label
        // Set the vertical offset for the placeholder
        customTextField.placeholderVerticalOffset = 5 // Adjust this value as needed
        customTextField.leftPadding = 5
        customTextField.layer.cornerRadius = 5
        customTextField.clipsToBounds = true
    }
    
    func buttonImageColor(button: UIButton){
        // Set the image rendering mode to alwaysTemplate to use tintColor
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .red
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
