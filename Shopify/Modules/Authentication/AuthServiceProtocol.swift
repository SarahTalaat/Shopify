import Foundation
import FirebaseAuth

protocol AuthServiceProtocol  {
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productVendor: String, productImage: String, isSignedIn: String) 
    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void)
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func addProductToEncodedEmail(email: String, productId: String, productTitle: String, productVendor: String, productImage: String)
    func deleteProductFromEncodedEmail(encodedEmail: String, productId: String)
    func retrieveAllProductsFromEncodedEmail(email: String, completion: @escaping ([ProductFromFirebase]) -> Void)
    func checkProductExists(email: String, productId: String, completion: @escaping (Bool, Error?) -> Void)
    func checkEmailSignInStatus(email: String, completion: @escaping (Bool?) -> Void)
    func updateSignInStatus(email: String, isSignedIn: String, completion: @escaping (Bool) -> Void)
    func toggleFavorite(email: String, productId: String, productTitle: String, productVendor: String, productImage: String, isFavorite: Bool, completion: @escaping (Error?) -> Void)
    func setShoppingCartId(email: String, shoppingCartId: String, completion: @escaping (Error?) -> Void)
    func getShoppingCartId(email: String, completion: @escaping (String?, Error?) -> Void)
    func fetchCustomerId(encodedEmail: String, completion: @escaping (String?) -> Void)
    func fetchFavorites(email: String, completion: @escaping ([String: Bool]) -> Void)
}
