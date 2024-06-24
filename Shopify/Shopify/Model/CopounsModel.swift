//
//  CopounsModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 21/06/2024.
//
 
import Foundation
 
// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int
    let valueType: ValueType
    let value: String
    let customerSelection: CustomerSelection
    let targetType: TargetType
    let targetSelection: TargetSelection
    let allocationMethod: AllocationMethod
    let allocationLimit: Int?
    let oncePerCustomer: Bool
    let usageLimit: Int?
    let startsAt: String
    let endsAt: String?
    let createdAt, updatedAt: String
    let entitledProductIds, entitledVariantIds, entitledCollectionIds, entitledCountryIds: [Int]
    let prerequisiteProductIds, prerequisiteVariantIds, prerequisiteCollectionIds, customerSegmentPrerequisiteIds, prerequisiteCustomerIds: [Int]
    let prerequisiteSubtotalRange, prerequisiteQuantityRange, prerequisiteShippingPriceRange: Range?
    let prerequisiteToEntitlementQuantityRatio: PrerequisiteToEntitlementQuantityRatio
    let prerequisiteToEntitlementPurchase: PrerequisiteToEntitlementPurchase
    let title, adminGraphqlAPIID: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case allocationLimit = "allocation_limit"
        case oncePerCustomer = "once_per_customer"
        case usageLimit = "usage_limit"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case entitledProductIds = "entitled_product_ids"
        case entitledVariantIds = "entitled_variant_ids"
        case entitledCollectionIds = "entitled_collection_ids"
        case entitledCountryIds = "entitled_country_ids"
        case prerequisiteProductIds = "prerequisite_product_ids"
        case prerequisiteVariantIds = "prerequisite_variant_ids"
        case prerequisiteCollectionIds = "prerequisite_collection_ids"
        case customerSegmentPrerequisiteIds = "customer_segment_prerequisite_ids"
        case prerequisiteCustomerIds = "prerequisite_customer_ids"
        case prerequisiteSubtotalRange = "prerequisite_subtotal_range"
        case prerequisiteQuantityRange = "prerequisite_quantity_range"
        case prerequisiteShippingPriceRange = "prerequisite_shipping_price_range"
        case prerequisiteToEntitlementQuantityRatio = "prerequisite_to_entitlement_quantity_ratio"
        case prerequisiteToEntitlementPurchase = "prerequisite_to_entitlement_purchase"
        case title
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}
 
enum ValueType: String, Codable {
    case percentage
}
 
enum CustomerSelection: String, Codable {
    case all
}
 
enum TargetType: String, Codable {
    case lineItem = "line_item"
}
 
enum TargetSelection: String, Codable {
    case entitled
}
 
enum AllocationMethod: String, Codable {
    case each
}
 
// MARK: - Range
struct Range: Codable {
    let prerequisiteQuantity, entitledQuantity: Int?
 
    enum CodingKeys: String, CodingKey {
        case prerequisiteQuantity = "prerequisite_quantity"
        case entitledQuantity = "entitled_quantity"
    }
}
 
// MARK: - PrerequisiteToEntitlementQuantityRatio
struct PrerequisiteToEntitlementQuantityRatio: Codable {
    let prerequisiteQuantity, entitledQuantity: Int?
 
    enum CodingKeys: String, CodingKey {
        case prerequisiteQuantity = "prerequisite_quantity"
        case entitledQuantity = "entitled_quantity"
    }
}
 
// MARK: - PrerequisiteToEntitlementPurchase
struct PrerequisiteToEntitlementPurchase: Codable {
    let prerequisiteAmount: Int?
 
    enum CodingKeys: String, CodingKey {
        case prerequisiteAmount = "prerequisite_amount"
    }
}
 
 
// MARK: - DiscountCode
struct DiscountCode: Codable {
    let id: Int
    let priceRuleID: Int
    let code: String
    let usageCount: Int
    let createdAt, updatedAt: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
 
struct Discount_Codes : Codable{
    let code: String
    let amount: String
    let type: String
    
}
