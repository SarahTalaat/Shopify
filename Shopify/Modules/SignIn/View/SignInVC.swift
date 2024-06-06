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
    
    private var viewModel: SignInViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSignInScreenUI()
        bindViewModel()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        bindViewModel()
    }
    
    func navToTabBar(){
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
    
    private func bindViewModel() {
            viewModel.bindUserViewModelToController = {
                // Handle successful sign-in, e.g., navigate to a different screen
                guard let email = self.emailCustomTextField.text, let password = self.passwordCustomTextField.text else { return }
                self.viewModel.signIn(email: email, password: password)
                self.navToTabBar()
            }
            
            viewModel.bindErrorViewModelToController = { [weak self] in
                DispatchQueue.main.async {
                    if let errorMessage = self?.viewModel.errorMessage {
                        // If the error is due to incorrect data, show an alert with options to cancel or sign up
                        if errorMessage == "Incorrect data" {
                            self?.showSignInErrorAlert()
                        }
                    }
                }
            }
        }
        
        private func showSignInErrorAlert() {
            let alert = UIAlertController(title: "Error", message: "Incorrect email or password", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { [weak self] _ in
                self?.navigateToSignUp()
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        private func navigateToSignUp() {
            // Navigate to the sign-up screen
            // You can use segue or present the sign-up view controller here
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let signUpVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
            navigationController?.pushViewController(signUpVC, animated: true)
            
        }
        

        
        func configure(viewModel: SignInViewModelProtocol) {
            self.viewModel = viewModel
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

