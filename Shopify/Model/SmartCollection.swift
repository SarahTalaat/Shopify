//
//  SmartCollection.swift
//  Shopify
//
//  Created by Haneen Medhat on 07/06/2024.
//

import Foundation
struct CollectionResponse: Decodable{
    let smart_collections :[SmartCollection]
}

struct SmartCollection:Decodable {
    let id: Int
    let title: String
    let image : SmartImage
  
}

struct SmartImage: Decodable{
    let src: String
}
