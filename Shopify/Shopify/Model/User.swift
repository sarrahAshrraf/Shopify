//
//  User.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import Foundation

struct User: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email :String?
    var phone: String?
    var addresses: [Address]?
    var tags: String?
    var note: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case addresses, tags
    }
}
