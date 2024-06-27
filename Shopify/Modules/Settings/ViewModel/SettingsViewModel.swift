//
//  SettingsViewModel.swift
//  Shopify
//
//  Created by Sara Talat on 12/06/2024.
//

import Foundation

class SettingsViewModel: SettingsViewModelProtocol{
  

    let authServiceProtocol: AuthServiceProtocol
    
    init(authServiceProtocol: AuthServiceProtocol) {
        self.authServiceProtocol = authServiceProtocol
    }
    private var addresses: [Address] = []
    private let networkService = NetworkServiceAuthentication()
    var currentAddress: String {
        if let defaultAddress = addresses.first(where: { $0.default ?? false }) {
            return defaultAddress.city
        } else {
            return "No Default Address"
        }
    }
    var errorMessage: String? {
        didSet {
            print("vm Error message updated: \(String(describing: errorMessage))")
            bindErrorViewModelToController()
        }
    }
    
    var isSignedOut: Bool? {
        didSet {
            print("vm SignOut true")
            bindLogOutStatusViewModelToController()
        }
    }
    
    var bindLogOutStatusViewModelToController: (() -> ()) = {}
    var bindErrorViewModelToController: (() -> ()) = {}
    
 
    func signOut(isSignedOut: Bool) {
        print("print signOut")
        authServiceProtocol.signOut { result in
            switch result {
            case .success:
                print("User signed out successfully")
                self.isSignedOut = isSignedOut
                SharedDataRepository.instance.isSignedIn = false
                SharedDataRepository.instance.customerEmail = nil
            case .failure(let error):

                print("Failed to sign out: \(error.localizedDescription)")
                self.handleSignUpError(error)

            }
        }
    }
    
    func fetchDefaultAddress(completion: @escaping (Result<Void, Error>) -> Void) {
          guard let customerId = SharedDataRepository.instance.customerId else {
              let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Customer ID is missing"])
              completion(.failure(error))
              return
          }
          
          let urlString = "https://\(APIConfig.apiKey):\(APIConfig.password)@\(APIConfig.hostName)/admin/api/\(APIConfig.version)/customers/\(customerId)/addresses.json?limit"
          networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { [weak self] (result: Result<AddressListResponse, Error>) in
              switch result {
              case .success(let response):
                  self?.addresses = response.addresses
                  completion(.success(()))
              case .failure(let error):
                  print("Failed to fetch addresses: \(error)")
                  completion(.failure(error))
              }
          }
      }
    func handleSignUpError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
