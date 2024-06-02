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
        CustomButton.buttonRoundedCorner(button: signUpButton)
    }
    
    func setUpSignUpScreenUI(){
        CustomTextField.customTextFieldUI(customTextField: nameCustomTextField, label: "Name : ")
        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
        CustomButton.buttonImageColor(button: alreadySignedInCustomButton)
        CustomButton.buttonShadow(button: signUpButton)
        CustomButton.setupButton(alreadySignedInCustomButton)
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
