//
//  Rules.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 07/06/2024.
//

import Foundation
struct Rules: Codable {
    
    let column: String?
    let relation: String?
    let condition: String?
    
    private enum CodingKeys: String, CodingKey {
        case column = "column"
        case relation = "relation"
        case condition = "condition"
    }
    
}
