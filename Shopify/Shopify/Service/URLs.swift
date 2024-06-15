//
//  URLs.swift
//  Shopify
//
//  Created by Ahmed Refat on 07/06/2024.
//

import Foundation
class URLs{
    
    static let shared = URLs()
    let defaults = UserDefaults.standard
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
    
    func getAddressURL(customerId: String = "") -> String{
        //MARK: TODO: Change the customer id to take it from keychainnnnn
        endPoint = "customers/\(UserDefaults.standard.integer(forKey: Constants.customerId))/addresses"
        return baseURL + endPoint + ".json"
    }

    
    func productDetails(id : Int) -> String{
        return baseURL + "products/\(id).json"
    }
    
    func allProduct() -> String{
        return baseURL + "products.json"
    }
    
    func getProductCategory(id: Int) -> String{
        return baseURL + "collections/\(id)/products.json"
    }
    func getAddressURLForModification(customerID: String = "", addressID: String = "") -> String{
        //MARK: TODO: Change the customer id to take it from keychainnnnn
        endPoint = "customers/\(UserDefaults.standard.integer(forKey: Constants.customerId))/addresses/\(addressID)"
        return baseURL + endPoint + ".json"
    }
    
    func getCartItems(cartId: Int) -> String{
        //945806409901
        endPoint = "draft_orders/\(cartId)"
        return baseURL + endPoint + ".json"
    }
    
    func postOrderURL() -> String{
        endPoint = "orders"
        print(baseURL + endPoint + ".json")
        return baseURL + endPoint + ".json"
    }
    
    func postInventoryURL() -> String{
        endPoint = "inventory_levels/set"
        print(baseURL + endPoint + ".json")
        return baseURL + endPoint + ".json"
    }
    func customersURL() -> String{
        return baseURL + "customers.json"
    }
    
    func postDraftOrder() -> String{
        return baseURL + "draft_orders.json"
    }
    
    func customerWithDraftOrder() -> String{
        return baseURL + "customers/\(UserDefaults.standard.integer(forKey: Constants.customerId)).json"
    }
    
    
    func favouriteDraftOrder() -> String{
        return baseURL + "draft_orders/\(defaults.integer(forKey: Constants.favoritesId)).json"
        
    }
  
    func getOrders() -> String {
        return baseURL + "orders.json"
    }
    
    func getAllProducts() -> String {
        return baseURL + "products.json"
    }
    
}
