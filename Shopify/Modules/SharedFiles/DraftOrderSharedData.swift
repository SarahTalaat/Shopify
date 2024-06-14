//
//  DraftOrderSharedData.swift
//  Shopify
//
//  Created by Sara Talat on 14/06/2024.
//

import Foundation

class DraftOrderSharedData {
    
    static let instance = DraftOrderSharedData()
    private init() {}
    
    var draftOrder: OneDraftOrderResponse?
    
}
