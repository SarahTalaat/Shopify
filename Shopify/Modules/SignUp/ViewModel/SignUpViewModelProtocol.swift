//
//  SignUpViewModelProtocol.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation

import Foundation

protocol SignUpViewModelProtocol {
    var user: UserModel? { get }
    var errorMessage: String? { get }
    var bindUserViewModelToController: (() -> ()) { get set }
    var bindErrorViewModelToController: (() -> ()) { get set }
    
    func signUp(firstName: String, email: String, verifiedEmail: Bool) 
}
