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
    func setDefaultAddress(at indexPath: IndexPath) {
            let selectedAddress = addresses[indexPath.row]
            guard selectedAddress.id != selectedDefaultAddressId else { return }
            
        TryAddressNetworkService.shared.updateAddress(addressId: selectedAddress.id!, isDefault: true) { [weak self] result in
                switch result {
                case .success:
                    self?.selectedDefaultAddressId = selectedAddress.id
                    self?.addresses.indices.forEach { self?.addresses[$0].default = $0 == indexPath.row }
                    self?.onAddressesUpdated?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
}
