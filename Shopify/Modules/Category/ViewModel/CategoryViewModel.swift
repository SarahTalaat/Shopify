//
//  CategoryViewModel.swift
//  Shopify
//
//  Created by Haneen Medhat on 10/06/2024.
//

import Foundation

class CategoryViewModel{
    
    var category : [Products] = [] {
        didSet{
            bindCategory()
        }
    }
    
    var bindCategory : (()->()) = {}
    
    init(){
        getCategory()
    }

    func getCategory(){
        NetworkUtilities.fetchData(responseType: <#T##T#>, endpoint: <#T##String#>, completion: <#T##(T?) -> Void#>)
    }
    
    
    
    
    
    
    
    
    
}
