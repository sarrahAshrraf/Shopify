//
//  CartModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import Foundation

//struct DraftOrder: Codable {
//    let id: Int?
//    let note: String?
//    var lineItems: [LineItems]?
//    let user: User?
//    var total_price : String?
//    var subtotal_price : String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case note
//        case lineItems = "line_items"
//        case user = "customer"
//    }
//}
struct DraftOrder : Codable {
    var id : Int?
    var note : String?
    var email : String?
    var taxes_included : Bool?
    var currency : String?
    var invoice_sent_at : String?
    var created_at : String?
    var updated_at : String?
    var tax_exempt : Bool?
    var compvared_at : String?
    var name : String?
    var status : String?
    var line_items : [LineItems]?
    var shipping_address : Shipping_address?
//    var billing_address : Billing_address?
    var invoice_url : String?
    var applied_discount : Applied_discount?
    var order_id : Int?
    var shipping_line : String?
//    var tax_lines : [TaxLine]?
    var tags : String?
    var note_attributes : [String]?
    var total_price : String?
    var subtotal_price : String?
    var total_tax : String?
    var payment_terms : String?
    var admin_graphql_api_id : String?
    var customer : User?
    init(id: Int?, note: String?, line_items: [LineItems]?, customer: User?) {
        self.id = id
        self.note = note
        self.line_items = line_items
        self.customer = customer
    }
}
struct Shipping_address : Codable {
    let first_name : String?
    let address1 : String?
    let phone : String?
    let city : String?
    let zip : String?
    let province : String?
    let country : String?
    let last_name : String?
    let address2 : String?
    let company : String?
    let name : String?
    let country_code : String?
    let province_code : String?

}
struct Applied_discount : Codable {
    let description : String?
    let value : String?
    let title : String?
    let amount : String?
    let value_type : String?


}
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

struct TotalPriceSet: Codable {
    
    let shopMoney: ShopMoney?
    let presentmentMoney: ShopMoney?
    
    private enum CodingKeys: String, CodingKey {
        case shopMoney = "shop_money"
        case presentmentMoney = "presentment_money"
    }
    
}

struct ShopMoney: Codable {
    
    let amount: String?
    let currencyCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case currencyCode = "currency_code"
    }
    
}
struct Variant: Codable {
    let id: Int
    let productId: Int
    let title: String
    let price: String
    let sku: String
    let position: Int
    let inventoryPolicy: String
    let compareAtPrice: String?
    let fulfillmentService: String
    let inventoryManagement: String
    let option1: String
    let option2: String
    let option3: String?
    let createdAt: String
    let updatedAt: String
    let taxable: Bool
    let barcode: String?
    let grams: Int
    let weight: Double
    let weightUnit: String
    let inventoryItemId: Int
    let inventoryQuantity: Int
    let oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlApiId: String
    let imageId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2, option3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, barcode, grams, weight
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case imageId = "image_id"
    }
}
