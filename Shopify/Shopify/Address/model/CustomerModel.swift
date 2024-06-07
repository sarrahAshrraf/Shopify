//
//  CustomerModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import Foundation

struct Address: Codable {
    let id: Int
    let customerID: Int
    let firstName: String
    let lastName: String
    let company: String?
    let address1: String
    let address2: String?
    let city: String
    let province: String?
    let country: String
    let zip: String
    let phone: String
    let name: String
    let provinceCode: String?
    let countryCode: String
    let countryName: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1
        case address2
        case city
        case province
        case country
        case zip
        case phone
        case name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case isDefault = "default"
    }
}

struct MarketingConsent: Codable {
    let state: String
    let optInLevel: String
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

struct Customer: Codable {
    let id: Int
    let email: String
    let createdAt: String
    let updatedAt: String
    let firstName: String
    let lastName: String
    let ordersCount: Int
    let state: String
    let totalSpent: String
    let lastOrderID: Int?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency: String
    let phone: String
    let addresses: [Address]
    let taxExemptions: [String]
    let emailMarketingConsent: MarketingConsent
    let smsMarketingConsent: MarketingConsent
    let adminGraphqlAPIID: String
    let defaultAddress: Address

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency
        case phone
        case addresses
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}

struct Root: Codable {
    let customers: [Customer]
}
