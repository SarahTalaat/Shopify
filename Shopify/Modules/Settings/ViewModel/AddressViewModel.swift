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
    var onAddressesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchAddresses() {
        TryAddressNetworkService.shared.getAddresses { [weak self] result in
            switch result {
            case .success(let addresses):
                self?.addresses = addresses
                self?.onAddressesUpdated?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func setDefaultAddress(at indexPath: IndexPath) {
        guard indexPath.row < addresses.count else { return }
        let previousDefaultIndex = addresses.firstIndex { $0.default == true }
        for i in 0..<addresses.count {
            addresses[i].default = false
        }
        addresses[indexPath.row].default = true
        selectedDefaultAddressId = addresses[indexPath.row].id
        TryAddressNetworkService.shared.updateAddress(address: addresses[indexPath.row]) { [weak self] result in
            switch result {
            case .success:
                self?.onAddressesUpdated?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func deleteAddress(at indexPath: IndexPath) {
        guard indexPath.row < addresses.count else { return }
        let address = addresses[indexPath.row]
        if let addressId = address.id {
            TryAddressNetworkService.shared.deleteAddress(addressId: addressId) { [weak self] result in
                switch result {
                case .success:
                    self?.addresses.remove(at: indexPath.row)
                    self?.onAddressesUpdated?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
}
