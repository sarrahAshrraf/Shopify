//
//  LineItems.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 13/06/2024.
//

import Foundation
struct LineItems: Codable {
    
    var id: Int?
    var adminGraphqlApiId: String?
    var fulfillableQuantity: Int?
    var fulfillmentService: String?
    var giftCard: Bool?
    var grams: Int?
    var name: String?
    var price: String?
    var priceSet: TotalPriceSet?
    var productExists: Bool?
    var productId: Int?
    var quantity: Int?
    var requiresShipping: Bool?
    var sku: String?
    var taxable: Bool?
    var title: String?
    var totalDiscount: String?
    var totalDiscountSet: TotalPriceSet?
    var variantId: Int?
    var variantInventoryManagement: String?
    var variantTitle: String?
    var vendor: String?
    var properties: [Properties]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case fulfillableQuantity = "fulfillable_quantity"
        case fulfillmentService = "fulfillment_service"
        case giftCard = "gift_card"
        case grams = "grams"
        case name = "name"
        case price = "price"
        case priceSet = "price_set"
        case productExists = "product_exists"
        case productId = "product_id"
        case quantity = "quantity"
        case requiresShipping = "requires_shipping"
        case sku = "sku"
        case taxable = "taxable"
        case title = "title"
        case totalDiscount = "total_discount"
        case totalDiscountSet = "total_discount_set"
        case variantId = "variant_id"
        case variantInventoryManagement = "variant_inventory_management"
        case variantTitle = "variant_title"
        case vendor = "vendor"
        case properties
    }
    
}

struct Properties: Codable {
    let name: String?
    let value: String?
}
