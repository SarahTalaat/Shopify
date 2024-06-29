//
//  NewAddressViewModel.swift
//  Shopify
//
//  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
//

import Foundation
class NewAddressViewModel {
    var fullName: String = ""
    var newAddress: String = ""
    var city: String = ""
    var state: String = ""
    var zipCode: String = ""
    var customerId: String = ""
    var addresses: [Address] = []
    var onError: ((Error) -> Void)?
    private let networkService = NetworkServiceAuthentication.instance
    
    var egyptGovernorates = [
        "Cairo", "Alexandria", "Giza", "Port Said", "Suez", "Luxor", "Aswan", "Asyut",
        "Beheira", "Beni Suef", "Dakahlia", "Damietta", "Faiyum", "Gharbia", "Ismailia",
        "Kafr El Sheikh", "Matruh", "Minya", "Monufia", "New Valley", "North Sinai",
        "Qalyubia", "Qena", "Red Sea", "Sharqia", "Sohag", "South Sinai"
    ]
    
    init(networkService: NetworkServiceAuthentication = NetworkServiceAuthentication.instance) {
            self.networkService = networkService
    
    func isAddressValid() -> Bool {
        return !fullName.isEmpty &&
            !newAddress.isEmpty &&
            !city.isEmpty &&
            !state.isEmpty &&
            !zipCode.isEmpty &&
            state.lowercased() == "egypt"
    }
    
    func postNewAddress(completion: @escaping (Result<Address, Error>) -> Void) {
        let address = Address(id: nil, first_name: fullName, address1: newAddress, city: city, country: state, zip: zipCode, `default`: false)
          
        let parameters: [String: Any] = [
            "address": [
                "first_name": address.first_name,
                "address1": address.address1,
                "city": address.city,
                "country": address.country,
                "zip": address.zip,
                "default": address.default ?? false
            ]
        ]
        
        let urlString = APIConfig.addresses(customerId: customerId).url
        
        networkService.requestFunction(urlString: urlString, method: .post, model: parameters) { [weak self] (result: Result<AddressResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.addresses.append(response.customer_address)
                completion(.success(response.customer_address))
            case .failure(let error):
                self.onError?(error)
                completion(.failure(error))
            }
        }
    }
}
