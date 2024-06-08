//
//  Response.swift
//  Shopify
//
//  Created by Ahmed Refat on 05/06/2024.
//

import Foundation


struct Response : Codable{
    let smartCollections: [SmartCollections]?
    //let addresses: [Address]
    let products: [Product]?
    let product: Product?
    
    private enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
        //case addresses
        case products = "products"
        case product = "product"
        
    }
}
