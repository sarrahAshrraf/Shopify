//
//  Response.swift
//  Shopify
//
//  Created by Ahmed Refat on 05/06/2024.
//

import Foundation


struct Response : Codable{
    let smartCollections: [SmartCollections]?
    
    private enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
        
    }
}
