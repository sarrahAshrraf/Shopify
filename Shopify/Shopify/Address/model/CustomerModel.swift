//
//  CustomerModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import Foundation
struct Address: Codable {
    let id: Int?
    let customer_id: Int?
    let name: String?
    let first_name: String?
    let last_name: String?
    let phone: String?
        let company: String?

    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let province_code: String?
    let country_code: String?
    let country_name: String?
    var `default`: Bool?
}

