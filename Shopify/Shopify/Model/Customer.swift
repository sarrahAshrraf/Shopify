//
//  Customer.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 12/06/2024.
//

import Foundation
struct Customer: Codable {
    
    let id: Int
    let email: String?
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
    let defaultAddress: DefaultAddress?
    
   
    init(id: Int) {
        self.id = id
        self.email = nil
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
        self.defaultAddress = nil
    }
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
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
        case defaultAddress = "default_address"
    }
    
}
