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
    @IBOutlet var firstNameCustomTextField: CustomTextField!
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSignUpScreenUI()
        makeCircularImage()
        viewModel = DependencyProvider.signUpViewModel
        
        viewModel.networkStatusChanged = { isReachable in
                  if !isReachable {
                      self.showAlerts(title: "No Internet Connection", message: "Please check your WiFi connection.")
                  }
              }
        
        bindViewModel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction private func signUpButton(_ sender: UIButton) {

        
        guard let firstName = firstNameCustomTextField.text, !firstName.isEmpty,
              let email = emailCustomTextField.text, !email.isEmpty,
              let password = passwordCustomTextField.text, !password.isEmpty else {
            
            // Show alert if any field is empty
            showSignSuccessfulAlert(title: "Error", message: "All fields are required.", button1Title: "Ok"){
                print("Alert dismissed")
            }
            return
        }
        
        // Call the sign up method if all fields are entered
        viewModel.signUp(email: email, password: password, firstName: firstName)
    }
        
    

    
    
    private func bindViewModel() {
        viewModel.bindUserViewModelToController = {
            self.showSignSuccessfulAlert(title: "Alert!", message: "You have to check your email to verify your account in order to be able to sign in", button1Title: "Ok") {
                self.navToSignIn()
            }
        }
        
        viewModel.bindErrorViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    self?.showSignSuccessfulAlert(title: "Failure", message: "\(errorMessage)", button1Title: "Ok", completion: {})
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
    
    func navToHome() {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            UIApplication.shared.windows.first?.rootViewController = tabBarController
        }
    }
    
    func navToSignIn() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CustomButton.buttonRoundedCorner(button: signUpButton)
    }
    
    func setUpSignUpScreenUI() {
        CustomTextField.customTextFieldUI(customTextField: firstNameCustomTextField, label: "First Name : ")
        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
        CustomButton.buttonImageColor(button: alreadySignedInCustomButton)
        CustomButton.buttonShadow(button: signUpButton)
        CustomButton.setupButtonTitle(alreadySignedInCustomButton)
        CustomButton.setupButtonTitle(signUpButton)
    }
    
    private func showSignSuccessfulAlert(title: String, message: String, button1Title: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button1Title, style: .cancel) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }
}
