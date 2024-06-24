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
    let draft_order: DraftOrder?
    let orders: [Orders]?
    let order: Orders?
    let currencies: [Currency]?
    let base: String?
    let rates: Rates?
    var price_rules: [PriceRule]?
    var price_rule: PriceRule?
    var discount_codes: [DiscountCode]?
    var discount_code: DiscountCode?

}
