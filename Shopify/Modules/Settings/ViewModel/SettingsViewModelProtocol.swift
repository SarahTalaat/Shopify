//
//  SettingsViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 12/06/2024.
//

import Foundation

protocol SettingsViewModelProtocol {
    
    var isSignedOut: Bool? { get }
    var errorMessage: String? { get }
    var bindLogOutStatusViewModelToController: (() -> ()) { get set }
    var bindErrorViewModelToController: (() -> ()) { get set }
    func signOut(isSignedOut: Bool)
    var currentAddress: String { get }
    func fetchDefaultAddress(completion: @escaping (Result<Void, Error>) -> Void)
}
