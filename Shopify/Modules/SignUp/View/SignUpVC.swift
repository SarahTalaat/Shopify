////
////  SignUpVC.swift
////  Shopify
////
////  Created by Sara Talat on 01/06/2024.
////
//
//import UIKit
//
//class SignUpVC: UIViewController {
//
//    @IBOutlet weak var logoImage: UIImageView!
//    @IBOutlet var passwordCustomTextField: CustomTextField!
//    @IBOutlet var signUpButton: UIButton!
//    @IBOutlet var alreadySignedInCustomButton: UIButton!
//    @IBOutlet var emailCustomTextField: CustomTextField!
//    @IBOutlet var nameCustomTextField: CustomTextField!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        setUpSignUpScreenUI()
//        makeCircularImage()
//
//    }
//
//
//    @IBAction func alreadyHaveAnAccountButtonTapped(_ sender: UIButton) {
//        navToSignIn()
//
//    }
//
//    func makeCircularImage() {
//        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
//        logoImage.clipsToBounds = true
//    }
//    @IBAction func signUpButton(_ sender: UIButton) {
//
//        navToSignIn()
//
//    }
//    @IBAction func continueAsAGuestButtonTapped(_ sender: UIButton) {
//
//        navToHome()
//    }
//
//    func navToHome(){
//        let storyboard = UIStoryboard(name: "Second", bundle: nil)
//        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
//            // If you want to set it as the root view controller
//            UIApplication.shared.windows.first?.rootViewController = tabBarController
//        }
//    }
//
//    func navToSignIn(){
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let signInVC = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//        navigationController?.pushViewController(signInVC, animated: true)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        // Ensure the button's corners are rounded
//        CustomButton.buttonRoundedCorner(button: signUpButton)
//    }
//
//    func setUpSignUpScreenUI(){
//        CustomTextField.customTextFieldUI(customTextField: nameCustomTextField, label: "Name : ")
//        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
//        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
//        CustomButton.buttonImageColor(button: alreadySignedInCustomButton)
//        CustomButton.buttonShadow(button: signUpButton)
//        CustomButton.setupButtonTitle(alreadySignedInCustomButton)
//        CustomButton.setupButtonTitle(signUpButton)
//    }
//
//
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
////-------------
////
////  SignUpVC.swift
////  Shopify
////
////  Created by Sara Talat on 01/06/2024.
////

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet var passwordCustomTextField: CustomTextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var alreadySignedInCustomButton: UIButton!
    @IBOutlet var emailCustomTextField: CustomTextField!
    @IBOutlet var nameCustomTextField: CustomTextField!
    var viewModel: SignUpViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSignUpScreenUI()
        makeCircularImage()
        bindViewModel()
        
        viewModel = DependencyProvider.signUpViewModel

    }
    
    @IBAction private func signUpButton(_ sender: UIButton) {
        guard let name = nameCustomTextField.text, let email = emailCustomTextField.text, let password = passwordCustomTextField.text else { return }
        viewModel.signUp(email: email, password: password)
    }
    
    private func bindViewModel() {
        viewModel.bindUserViewModelToController = {
            // Handle successful sign-up, e.g., navigate to a different screen
            self.showSignSuccessfulAlert(title: "Success", message: "You have created an account successfully , click ok to sign in", button1Title: "Ok")
            self.navToSignIn()
        }
        
        viewModel.bindErrorViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    // Handle error message if needed
                    self?.showSignSuccessfulAlert(title: "Failure", message: "Failed to creeate a new account , click Ok and try again", button1Title: "Ok")
                }
            }
        }
    }
    
    @IBAction func alreadyHaveAnAccountButtonTapped(_ sender: UIButton) {
        navToSignIn()
        
    }
    
    func makeCircularImage() {
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
        logoImage.clipsToBounds = true
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
    

    private func showSignSuccessfulAlert(title: String , message: String , button1Title:String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: button1Title, style: .cancel, handler: nil))
    
        present(alert, animated: true, completion: nil)
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

