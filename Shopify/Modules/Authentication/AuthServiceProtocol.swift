import Foundation
import FirebaseAuth

protocol AuthServiceProtocol  {
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
//    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String)
    func saveCustomerId(name: String, email: String, id: String, favouriteId: String, shoppingCartId: String, productId: String, productTitle: String, productSize: String, productColour: String, productImage: String)
    func fetchCustomerDataFromRealTimeDatabase(forEmail email: String, completion: @escaping (CustomerData?) -> Void)
    func isEmailTaken(email: String, completion: @escaping (Bool) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func addProduct(email: String, productId: String, productTitle: String, productSize: String, productColour: String, productImage: String, completion: @escaping (Bool) -> Void)
    func deleteProduct(email: String, productId: String, completion: @escaping (Bool) -> Void)
    func updateProduct(forEmail email: String, productId: String, updatedProductData: [String: Any], completion: @escaping (Bool) -> Void)
    func fetchProducts(forEmail email: String, completion: @escaping ([CustomProduct]?) -> Void)
}
