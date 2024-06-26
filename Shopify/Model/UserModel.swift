//
//  UserModel.swift
//  Shopify
//
//  Created by Sara Talat on 06/06/2024.
//

import Foundation

struct UserModel {
    let uid: String
    let email: String
}

struct UserCredentials{
    let verified_email: Bool
    let email: String
    let first_name: String
}
