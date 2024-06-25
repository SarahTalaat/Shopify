//
//  AddressViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
//

import Foundation
class AddressViewModel {
    var addresses: [Address] = []
    var selectedDefaultAddressId: Int?
    var customerId: String = ""
    var onAddressesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let networkService = NetworkServiceAuthentication()
    
    func fetchAddresses() {
        let urlString = "https://\(APIConfig.apiKey):\(APIConfig.password)@\(APIConfig.hostName)/admin/api/\(APIConfig.version)/customers/\(customerId)/addresses.json?limit"
        
        networkService.requestFunction(urlString: urlString, method: .get, model: [:]) { [weak self] (result: Result<AddressListResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print(response)
                self.addresses = response.addresses
                self.onAddressesUpdated?()
            case .failure(let error):
                print("Error: \(error)")
                self.onError?(error)
            }
        }
    }

    
    func deleteAddress(at indexPath: IndexPath) {
        guard indexPath.row < addresses.count else { return }
        let address = addresses[indexPath.row]
        guard let addressId = address.id else { return }

        let urlString = APIConfig.endPoint("customers/\(customerId)/addresses/\(addressId)").url

        networkService.requestFunction(urlString: urlString, method: .delete, model: [:]) { [weak self] (result: Result<EmptyResponse, Error>) in
            guard let self = self else { return }

            switch result {
            case .success(_):
                self.addresses.remove(at: indexPath.row)
                self.onAddressesUpdated?()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func setDefaultAddress(at indexPath: IndexPath) {
            guard indexPath.row < addresses.count else { return }
            let selectedAddress = addresses[indexPath.row]
            guard let addressId = selectedAddress.id else { return }

            updateAddress(addressId: addressId, isDefault: true) { [weak self] result in
                switch result {
                case .success:
                    self?.selectedDefaultAddressId = addressId
                    self?.addresses.indices.forEach { self?.addresses[$0].default = ($0 == indexPath.row) }
                    self?.onAddressesUpdated?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
        
    func updateAddress(addressId: Int, isDefault: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = APIConfig.endPoint("customers/\(customerId)/addresses/\(addressId)").url
        
        let parameters: [String: Any] = [
            "address": [
                "default": isDefault
            ]
        ]
        
        networkService.requestFunction(urlString: urlString, method: .put, model: parameters) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }

            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("Error: \(error)")
                self.onError?(error)
                completion(.failure(error))
            }
        }
    }
}
