//
//  Order.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import Foundation

struct Orders: Codable {
    
    let id: Int?
    let contactEmail: String?
    let createdAt: String?
    let currency: String?
    let currentSubtotalPrice: String?
    let currentSubtotalPriceSet: TotalPriceSet?
    let currentTotalDiscounts: String?
    let currentTotalDiscountsSet: TotalPriceSet?
    let currentTotalPrice: String?
    let currentTotalPriceSet: TotalPriceSet?
    let currentTotalTax: String?
    let currentTotalTaxSet: TotalPriceSet?
    let email: String?
    let estimatedTaxes: Bool?
    let financialStatus: String?
    let name: String?
    let number: Int?
    let orderNumber: Int?
    let orderStatusUrl: String?
    let presentmentCurrency: String?
    let processedAt: String?
    let sourceName: String?
    let subtotalPrice: String?
    let subtotalPriceSet: TotalPriceSet?
    let tags: String?
    let taxesIncluded: Bool?
    let test: Bool?
    let token: String?
    let totalDiscounts: String?
    let totalDiscountsSet: TotalPriceSet?
    let totalLineItemsPrice: String?
    let totalLineItemsPriceSet: TotalPriceSet?
    let totalOutstanding: String?
    let totalPrice: String?
    let totalTax: String?
    let totalTaxSet: TotalPriceSet?
    let totalTipReceived: String?
    let totalWeight: Int?
    let updatedAt: String?
    let customer: Customer?
    let lineItems: [LineItems]?
    let shippingAddress: BillingAddress?
    
    init(currency: String, lineItems: [LineItems], number: Int, customer: Customer, totalPrice: String) {
        self.currency = currency
        self.lineItems = lineItems
        self.totalPrice = totalPrice
        self.number = number
        self.id = nil
        self.customer = customer
        self.shippingAddress = nil
        self.updatedAt = nil
        self.totalWeight = nil
        self.totalTax = nil
        self.totalTaxSet = nil
        self.totalTipReceived = nil
        self.presentmentCurrency = nil
        self.processedAt = nil
        self.sourceName = nil
        self.subtotalPrice = nil
        self.subtotalPriceSet = nil
        self.tags = nil
        self.taxesIncluded = nil
        self.test = nil
        self.token = nil
        self.totalDiscounts = nil
        self.totalDiscountsSet = nil
        self.totalLineItemsPrice = nil
        self.totalLineItemsPriceSet = nil
        self.totalOutstanding = nil
        self.email = nil
        self.estimatedTaxes = nil
        self.financialStatus = nil
        self.name = nil
        self.orderNumber = nil
        self.orderStatusUrl = nil
        self.contactEmail = nil
        self.createdAt = nil
        self.currentSubtotalPrice = nil
        self.currentSubtotalPriceSet = nil
        self.currentTotalDiscounts = nil
        self.currentTotalDiscountsSet = nil
        self.currentTotalPrice = nil
        self.currentTotalPriceSet = nil
        self.currentTotalTax = nil
        self.currentTotalTaxSet = nil
        
    }
    
    init(currency: String, lineItems: [LineItems], number: Int, customer: Customer, totalPrice: String, shippingAddress: BillingAddress) {
        self.currency = currency
        self.lineItems = lineItems
        self.totalPrice = totalPrice
        self.number = number
        self.id = nil
        self.customer = customer
        self.shippingAddress = shippingAddress
        self.updatedAt = nil
        self.totalWeight = nil
        self.totalTax = nil
        self.totalTaxSet = nil
        self.totalTipReceived = nil
        self.presentmentCurrency = nil
        self.processedAt = nil
        self.sourceName = nil
        self.subtotalPrice = nil
        self.subtotalPriceSet = nil
        self.tags = nil
        self.taxesIncluded = nil
        self.test = nil
        self.token = nil
        self.totalDiscounts = nil
        self.totalDiscountsSet = nil
        self.totalLineItemsPrice = nil
        self.totalLineItemsPriceSet = nil
        self.totalOutstanding = nil
        self.email = nil
        self.estimatedTaxes = nil
        self.financialStatus = nil
        self.name = nil
        self.orderNumber = nil
        self.orderStatusUrl = nil
        self.contactEmail = nil
        self.createdAt = nil
        self.currentSubtotalPrice = nil
        self.currentSubtotalPriceSet = nil
        self.currentTotalDiscounts = nil
        self.currentTotalDiscountsSet = nil
        self.currentTotalPrice = nil
        self.currentTotalPriceSet = nil
        self.currentTotalTax = nil
        self.currentTotalTaxSet = nil
        
    }
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case contactEmail = "contact_email"
        case createdAt = "created_at"
        case currency = "currency"
        case currentSubtotalPrice = "current_subtotal_price"
        case currentSubtotalPriceSet = "current_subtotal_price_set"
        case currentTotalDiscounts = "current_total_discounts"
        case currentTotalDiscountsSet = "current_total_discounts_set"
        case currentTotalPrice = "current_total_price"
        case currentTotalPriceSet = "current_total_price_set"
        case currentTotalTax = "current_total_tax"
        case currentTotalTaxSet = "current_total_tax_set"
        case email = "email"
        case estimatedTaxes = "estimated_taxes"
        case financialStatus = "financial_status"
        case name = "name"
        case number = "number"
        case orderNumber = "order_number"
        case orderStatusUrl = "order_status_url"
        case presentmentCurrency = "presentment_currency"
        case processedAt = "processed_at"
        case sourceName = "source_name"
        case subtotalPrice = "subtotal_price"
        case subtotalPriceSet = "subtotal_price_set"
        case tags = "tags"
        case taxesIncluded = "taxes_included"
        case test = "test"
        case token = "token"
        case totalDiscounts = "total_discounts"
        case totalDiscountsSet = "total_discounts_set"
        case totalLineItemsPrice = "total_line_items_price"
        case totalLineItemsPriceSet = "total_line_items_price_set"
        case totalOutstanding = "total_outstanding"
        case totalPrice = "total_price"
        case totalTax = "total_tax"
        case totalTaxSet = "total_tax_set"
        case totalTipReceived = "total_tip_received"
        case totalWeight = "total_weight"
        case updatedAt = "updated_at"
        case customer = "customer"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        
    }
    
}
struct Customer: Codable {
    
    let id: Int
    let email: String?
    let acceptsMarketing: Bool?
    let createdAt: String?
    let updatedAt: String?
    let firstName: String?
    let lastName: String?
    let state: String?
    let verifiedEmail: Bool?
    let taxExempt: Bool?
    let phone: String?
    let tags: String?
    let currency: String?
    let acceptsMarketingUpdatedAt: String?
    let adminGraphqlApiId: String?
    let defaultAddress: DefaultAddress?
    
    init(id: Int, email: String?, acceptsMarketing: Bool?, createdAt: String?, updatedAt: String?, firstName: String?, lastName: String?, state: String?, verifiedEmail: Bool?, taxExempt: Bool?, phone: String?, tags: String?, currency: String?, acceptsMarketingUpdatedAt: String?, adminGraphqlApiId: String?, defaultAddress: DefaultAddress?) {
        self.id = id
        self.email = email
        self.acceptsMarketing = acceptsMarketing
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.firstName = firstName
        self.lastName = lastName
        self.state = state
        self.verifiedEmail = verifiedEmail
        self.taxExempt = taxExempt
        self.phone = phone
        self.tags = tags
        self.currency = currency
        self.acceptsMarketingUpdatedAt = acceptsMarketingUpdatedAt
        self.adminGraphqlApiId = adminGraphqlApiId
        self.defaultAddress = defaultAddress
    }
    init(id: Int) {
        self.id = id
        self.email = nil
        self.acceptsMarketing = nil
        self.createdAt = nil
        self.updatedAt = nil
        self.firstName = nil
        self.lastName = nil
        self.state = nil
        self.verifiedEmail = nil
        self.taxExempt = nil
        self.phone = nil
        self.tags = nil
        self.currency = nil
        self.acceptsMarketingUpdatedAt = nil
        self.adminGraphqlApiId = nil
        self.defaultAddress = nil
    }
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case acceptsMarketing = "accepts_marketing"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case state = "state"
        case verifiedEmail = "verified_email"
        case taxExempt = "tax_exempt"
        case phone = "phone"
        case tags = "tags"
        case currency = "currency"
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
    
}
struct BillingAddress: Codable {
    
    let firstName: String
    let address1: String?
    let phone: String?
    let city: String?
    let zip: String?
    let country: String?
    let lastName: String?
    //    let address2: Any?
    //    let company: Any?
    //    let latitude: Any?
    //    let longitude: Any?
    let name: String?
    let countryCode: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case address1 = "address1"
        case phone = "phone"
        case city = "city"
        case zip = "zip"
        case country = "country"
        case lastName = "last_name"
        //        case address2 = "address2"
        //        case company = "company"
        //        case latitude = "latitude"
        //        case longitude = "longitude"
        case name = "name"
        case countryCode = "country_code"
    }
    
}
struct DefaultAddress: Codable {
    
    let id: Int
    let customerId: Int?
    let firstName: String?
    let lastName: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    // let province: Any?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    //   let provinceCode: Any?
    let countryCode: String?
    let countryName: String?
    let defaultField: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case customerId = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company = "company"
        case address1 = "address1"
        case address2 = "address2"
        case city = "city"
        //    case province = "province"
        case country = "country"
        case zip = "zip"
        case phone = "phone"
        case name = "name"
        //   case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case defaultField = "default"
    }
}
