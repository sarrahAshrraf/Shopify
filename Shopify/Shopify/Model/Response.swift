//
//  Response.swift
//  Shopify
//
//  Created by Ahmed Refat on 05/06/2024.
//

import Foundation


struct Response : Codable{
    let smart_collections: [SmartCollections]?
    let customer: User?
    let customers: [User]?
    let addresses: [Address]?
    let customer_address: Address?
    let products: [Product]?
    let product: Product?
    let orders: [Orders]?
    let order: Orders?
    
//    private enum CodingKeys: String, CodingKey {
//        case smartCollections = "smart_collections"
//        case customer,customers, addresses, customer_address
//        case products = "products"
//        case product = "product"
//        
//    }
//    Address_SB
}
