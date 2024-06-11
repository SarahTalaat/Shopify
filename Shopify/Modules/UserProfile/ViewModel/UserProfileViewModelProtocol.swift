//
//  UserProfileViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 11/06/2024.
//

import Foundation

protocol UserProfileViewModelProfileProtocol {
    var name: String? { get }
    var email: String? { get }
    var bindUserViewModelToController: (() -> ()) { get set }
    func userPersonalData()
}
