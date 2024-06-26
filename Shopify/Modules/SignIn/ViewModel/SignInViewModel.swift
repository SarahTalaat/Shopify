import Foundation
import FirebaseAuth
import Reachability

enum AuthErrorCode: Error {
    case wrongPassword
    case userNotFound
    case emailNotVerified
}

class SignInViewModel {
    static let sharedDataUpdateQueue = DispatchQueue(label: "com.Shopify.sharedDataUpdateQueue")

    var reachability: Reachability?
    var networkStatusChanged: ((Bool) -> Void)?
   
    var authService: FirebaseAuthService!
    var networkService: NetworkServiceAuthentication

    init(authService: FirebaseAuthService = FirebaseAuthService.instance , networkService:NetworkServiceAuthentication = NetworkServiceAuthentication.instance) {
        self.authService = authService
        self.networkService = networkService
    }
    
    var name: String?
    var email: String?
    var favId: String?
    var shopCartId: String?

    var user: UserModel? {
        didSet {
            self.bindUserViewModelToController()
        }
    }

    var errorMessage: String? {
        didSet {
            self.bindErrorViewModelToController()
        }
    }

    var id: String? {
        didSet {
            UserDefaults.standard.set(id, forKey: Constants.draftOrderId)
            print("kkk id didSet: \(id)")
        }
    }

    var customerID: String? {
        didSet {
            self.bindUserViewModelToController()
        }
    }

    var bindUserViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}



    func signIn(email: String, password: String) {
        FirebaseAuthService.instance.signIn(email: email, password: password) { [weak self] result in
            guard let strongSelf = self else {
                print("kkk self is nil in signIn completion")
                return
            }
            switch result {
            case .success(let user):
                strongSelf.user = user
                strongSelf.fetchCustomerID()
                SharedDataRepository.instance.customerEmail = email
                strongSelf.addValueToUserDefaults(value: email, forKey: Constants.customerEmail)
                print("ddd 1.")
                strongSelf.checkEmailSignInStatus(email: email)
                print("ddd 2.")
                print("ddd 3.")
              
            case .failure(let error):
                if let authError = error as? AuthErrorCode {
                    switch authError {
                    case .wrongPassword, .userNotFound:
                        strongSelf.errorMessage = "Invalid email or password"
                    case .emailNotVerified:
                        strongSelf.errorMessage = "Email not verified. Please check your email for a verification link."
                    default:
                        strongSelf.errorMessage = "An error occurred. Please try again later."
                    }
                } else {
                    strongSelf.errorMessage = "An error occurred. Please try again later."
                }
                
                
            }
        }
    }

    func updateSignInStatus(email: String) {
        FirebaseAuthService.instance.updateSignInStatus(email: email, isSignedIn: "\(true)") { success in
            if success {
                print("Sign-in status updated successfully.")
            } else {
                print("Failed to update sign-in status.")
            }
        }
    }

    func setupReachability() {
        reachability = try? Reachability()
        reachability?.whenReachable = { reachability in
            self.networkStatusChanged?(reachability.connection == .wifi)
            print("wifi connection")
        }
        reachability?.whenUnreachable = { _ in
            self.networkStatusChanged?(false)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    func checkEmailSignInStatus(email: String) {
        FirebaseAuthService.instance.checkEmailSignInStatus(email: email) { [self] isSignedIn in
            
            guard self != nil else {
                print("kkk self is nil in checkEmailSignInStatus completion")
                return
            }
            
            let strongSelf = self

            if isSignedIn ?? false {
                self.getDraftOrderID(email: email)
                print("kkk Email is signed in, no post will happen for draft order: \(isSignedIn)")
                self.getUserDraftOrderId()
            } else {
                let urlString = APIConfig.draft_orders.url
                let draftOrder1 = strongSelf.draftOrderDummyModel1()

                strongSelf.postDraftOrderForShoppingCart(urlString: urlString, parameters: draftOrder1 ?? [:], name: SharedDataRepository.instance.customerName ?? "NameXX", email: SharedDataRepository.instance.customerEmail ?? "EmailXX") { response in
                    
                    guard self != nil else {
                        print("kkk self is nil in postDraftOrder completion")
                        return
                    }

                    guard let shoppingCartId = response?.draftOrder?.id else {
                        print("kkk Draft order ID is nil.")
                        return
                    }
                    print("kkk Draft Order ID: \(shoppingCartId)")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        print("kkk Executing asyncAfter block")
                        strongSelf.setDraftOrderId(email: SharedDataRepository.instance.customerEmail ?? "No email", shoppingCartID: "\(shoppingCartId)")
                        self.getDraftOrderID(email: email)
                    }
                }
                strongSelf.updateSignInStatus(email: email)
            }

            SharedDataRepository.instance.isSignedIn = true
            print("kkk Firebase user ID: \(strongSelf.user?.uid ?? "No User ID")")
        }
    }
    
    

    func postDraftOrderForShoppingCart(urlString: String, parameters: [String: Any], name: String, email: String, completion: @escaping (OneDraftOrderResponse?) -> Void) {
        NetworkServiceAuthentication.instance.requestFunction(urlString: urlString, method: .post, model: parameters) { (result: Result<OneDraftOrderResponse, Error>) in
            switch result {
            case .success(let response):
                print("kkk Response ID: \(response.draftOrder?.id)")
                completion(response)
            case .failure(let error):
                print("kkk Failed to post draft order: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

     func fetchCustomerID() {
        guard let email = user?.email else {
            print("User email is nil")
            return
        }

        FirebaseAuthService.instance.fetchCustomerDataFromRealTimeDatabase(forEmail: email) { [self] customerDataModel in
            // Here we use [self] to capture self strongly

            // Ensure self is not nil
            guard self != nil else {
                print("kkk self is nil in fetchCustomerID completion")
                return
            }

            print("si: param email: \(email)")
            print("si: customerDataModel: \(customerDataModel ?? CustomerData(customerId: "NOOOID", name: "NOOOName", email: "NOOOEmail", favouriteId: "NOOOFavID", shoppingCartId: "NOOOShoppingID"))")
            SharedDataRepository.instance.customerName = customerDataModel?.name
            SharedDataRepository.instance.customerId = customerDataModel?.customerId
            SharedDataRepository.instance.shoppingCartId = customerDataModel?.shoppingCartId
            SharedDataRepository.instance.favouriteId = customerDataModel?.favouriteId

            print("si: inside: name: \(SharedDataRepository.instance.customerName ?? "NONAME")")
            print("si: inside email: \(SharedDataRepository.instance.customerEmail ?? "NOEMAIL")")
            print("si: inside: Cid: \(SharedDataRepository.instance.customerId ?? "NO CID")")
            print("si: inside: favId: \(SharedDataRepository.instance.favouriteId ?? "NO FID")")
            print("si: inside: shoppingCartId: \(SharedDataRepository.instance.shoppingCartId ?? "NO ShopID")")
        }
        SharedDataRepository.instance.customerEmail = user?.email
    }

    func draftOrderDummyModel1() -> [String: Any] {
        let draftOrder: [String: Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": 44465748574369,
                        "quantity": 1
                    ]
                ]
            ]
        ]

        return draftOrder
    }

    func draftOrderDummyModel2() -> [String: Any] {
        let draftOrder: [String: Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": 44465748574369,
                        "quantity": 1
                    ]
                ]
            ]
        ]

        return draftOrder
    }

    func addValueToUserDefaults(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func setDraftOrderId(email: String, shoppingCartID: String) {
        FirebaseAuthService.instance.setShoppingCartId(email: email, shoppingCartId: shoppingCartID) { error in
            if let error = error {
                print("Failed to set shopping cart ID: \(error.localizedDescription)")
            } else {
                print("Shopping cart ID set successfully!")
            }
        }
    }

    func getDraftOrderID(email: String) {
        FirebaseAuthService.instance.getShoppingCartId(email: email) { shoppingCartId, error in
            if let error = error {
                print("kkk Failed to retrieve shopping cart ID: \(error.localizedDescription)")
            } else if let shoppingCartId = shoppingCartId {
                print("kkk Shopping cart ID found: \(shoppingCartId)")
                SharedDataRepository.instance.draftOrderId = shoppingCartId
                print("kkk Singleton draft id: \(SharedDataRepository.instance.draftOrderId)")
                UserDefaults.standard.set(shoppingCartId, forKey: Constants.userDraftId) 
               print("kkk Draft order id UserDefaults si : \(UserDefaults.standard.string(forKey: Constants.userDraftId))")
            } else {
                print("kkk No shopping cart ID found for this user.")
            }
        }
    }
    
    func getUserDraftOrderId(){
        let email = SharedDataRepository.instance.customerEmail ?? "No email"
        self.getDraftOrderID(email: email)
    }
}
