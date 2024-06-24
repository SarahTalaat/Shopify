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
    
    var egyptGovernorates = [
        "Cairo", "Alexandria", "Giza", "Port Said", "Suez", "Luxor", "Aswan", "Asyut",
        "Beheira", "Beni Suef", "Dakahlia", "Damietta", "Faiyum", "Gharbia", "Ismailia",
        "Kafr El Sheikh", "Matruh", "Minya", "Monufia", "New Valley", "North Sinai",
        "Qalyubia", "Qena", "Red Sea", "Sharqia", "Sohag", "South Sinai"
    ]
    
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
        
        let networkService = NetworkServiceAuthentication()
        networkService.requestFunction(urlString: urlString, method: .post, model: parameters) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let addressResponse = try JSONDecoder().decode(AddressResponse.self, from: data)
                    completion(.success(addressResponse.customer_address))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error)) // Handle decoding error
                }
            case .failure(let error):
                print("Network error: \(error)")
                completion(.failure(error)) // Handle network error
            }
        }
    }
}
