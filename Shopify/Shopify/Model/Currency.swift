//
//  Currency.swift
//  Shopify
//
//  Created by sarrah ashraf on 16/06/2024.
//

import Foundation
struct Currency: Codable {
    let success: Bool?
    let timestamp: Int?
    let base, date: String?
    let rates: [String: Double]?
}
