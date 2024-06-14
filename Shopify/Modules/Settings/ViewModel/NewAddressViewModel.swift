////
////  NewAddressViewModel.swift
////  Shopify
////
////  Created by Marim Mohamed Mohamed Yacout on 13/06/2024.
////
//
//import Foundation
//class NewAddressViewModel {
//    let states = ["Cairo", "Alex", "portsaid", "mansora", "suiz"]
//
//    var fullName: String?
//    var newAddress: String?
//    var city: String?
//    var state: String?
//    var zipCode: String?
//    
//    var selectedDefaultAddressId: Int?
//    
//    var errorMessage: String? {
//        didSet {
//            bindErrorViewModelToController?()
//        }
//    }
//    
//    var successMessage: String? {
//        didSet {
//            bindSuccessViewModelToController?()
//        }
//    }
//    
//    var bindErrorViewModelToController: (() -> ())?
//    var bindSuccessViewModelToController: (() -> ())?
//
//    func saveAddress() {
//        guard let fullName = fullName, !fullName.isEmpty,
//              let newAddress = newAddress, !newAddress.isEmpty,
//              let city = city, !city.isEmpty,
//              let state = state, !state.isEmpty,
//              let zipCode = zipCode, !zipCode.isEmpty else {
//            errorMessage = "All fields are required."
//            return
//        }
//
//        let address = Address(id: nil, first_name: fullName, address1: newAddress, city: city, country: state, zip: zipCode, `default`: false)
//        
//        TryAddressNetworkService.shared.postNewAddress(address: address) { [weak self] result in
//            switch result {
//            case .success(let address):
//                print("Address successfully posted: \(address)")
//                if address.`default` ?? false {
//                    self?.selectedDefaultAddressId = address.id
//                }
//                self?.successMessage = "Address saved successfully."
//            case .failure(let error):
//                print("Failed to post address: \(error)")
//                self?.errorMessage = "Failed to save address. Please try again."
//            }
//        }
//    }
//}
