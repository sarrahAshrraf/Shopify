//
//  Options.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import Foundation

struct Options:Hashable, Codable {

    let id: Int?
    let productId: Int?
    let name: String?
    let position: Int?
    let values: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case name = "name"
        case position = "position"
        case values = "values"
    }
    
}
