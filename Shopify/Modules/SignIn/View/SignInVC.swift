import UIKit

class SignInVC: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var emailCustomTextField: CustomTextField!
    @IBOutlet var passwordCustomTextField: CustomTextField!
    
    var viewModel: SignInViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DependencyProvider.signInViewModel
        
        viewModel.networkStatusChanged = { isReachable in
                  if !isReachable {
                      self.showAlerts(title: "No Internet Connection", message: "Please check your WiFi connection.")
                  }
              }
        
        setUpSignInScreenUI()
        bindViewModel()
       
        
        print("Sign in view controller")
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
    
    
    @IBAction func signInButton(_ sender: UIButton) {

            guard let email = emailCustomTextField.text, !email.isEmpty,
                  let password = passwordCustomTextField.text, !password.isEmpty else {
                // Show alert if any field is empty
                showSignSuccessfulAlert(title: "Error", message: "All fields are required.", button1Title: "Ok"){
                    print("Alert dismissed")
                }
                return
            }
        
        viewModel.signIn(email: email, password: password)
    }
    
    
    
    
    
    private func showSignSuccessfulAlert(title: String, message: String, button1Title: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button1Title, style: .cancel) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func setUpSignInScreenUI() {
        CustomTextField.customTextFieldUI(customTextField: emailCustomTextField, label: "Email : ")
        CustomTextField.customTextFieldUI(customTextField: passwordCustomTextField, label: "Password : ")
    }
    
    private func bindViewModel() {
        viewModel.bindUserViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                self?.navToTabBar()
            }
        }
        
        viewModel.bindErrorViewModelToController = { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    self?.showSignInErrorAlert(title: "Error", message: "\(errorMessage) If you don't have an account you can sign up", button1Title: "OK", button2Title: "Sign Up")
                }
            }
        }
        

    }
    
    private func showSignInErrorAlert(title: String , message: String , button1Title:String , button2Title: String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: button1Title, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: button2Title, style: .default, handler: { [weak self] _ in
            self?.navigateToSignUp()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func navigateToSignUp() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let signUpVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func navToTabBar() {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            UIApplication.shared.windows.first?.rootViewController = tabBarController
        }
    }
    
    
    

}
