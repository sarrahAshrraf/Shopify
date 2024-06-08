//
//  URLs.swift
//  Shopify
//
//  Created by Ahmed Refat on 07/06/2024.
//

import Foundation
class URLs{
    
    static let shared = URLs()
    private init(){}
    let baseURL = "https://349c94c1c855b8b029a39104a4ae2e13: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@mad44-alx-ios-team1.myshopify.com/admin/api/2024-01/"
    private var endPoint = ""
    private var jsontype = ".json"
    
    func getBrandsURL() -> String{
       return baseURL +  "smart_collections.json"
    }
    
    func brandProductsURL(id : Int) -> String{
        return baseURL + "products.json?collection_id=\(id)"
    }
    
    func getAddressURL(addressId: String = "") -> String{
        //MARK: TODO: Change the customer id to take it from keychainnnnn
        endPoint = "customers/\(7309504250029)/addresses"
        return baseURL + endPoint + ".json"
    }
    
    func productDetails(id : Int) -> String{
        return baseURL + "products/\(id).json"
    }
    
}
