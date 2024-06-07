//
//  Response.swift
//  Shopify
//
//  Created by Ahmed Refat on 05/06/2024.
//

import Foundation


struct Response : Codable{
    let smartCollections: [SmartCollections]?
class Response : Codable{
//    let customers: [Customer]
    let addresses: [Address] 
    let products: [Product]?
    let product: Product?
    //let productDetails : ProductDetails?
    
    private enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
        
    }
}
