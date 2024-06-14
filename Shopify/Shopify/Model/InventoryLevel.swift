//
//  InventoryLevel.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import Foundation
struct InventoryLevel: Codable{
    var inventoryItemId: Int?
    var locationId: Int?
    var available: Int?
    var updatedAt: String?
    var adminGraphqlApiId: String?

    private enum CodingKeys: String, CodingKey {
        case inventoryItemId = "inventory_item_id"
        case locationId = "location_id"
        case available = "available"
        case updatedAt = "updated_at"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}
