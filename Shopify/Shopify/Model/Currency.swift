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
struct Rates: Codable {
    var AED: Double? = 1.0
    var AUD: Double? = 1.0
    var CAD: Double? = 1.0
    var CHF: Double? = 1.0
    var CZK: Double? = 1.0
    var DKK: Double? = 1.0
    var EGP: Double? = 1.0
    var EUR: Double? = 1.0
    var GBP: Double? = 1.0
    var HKD: Double? = 1.0
    var ILS: Double? = 1.0
    var JPY: Double? = 1.0
    var KRW: Double? = 1.0
    var MYR: Double? = 1.0
    var NZD: Double? = 1.0
    var PLN: Double? = 1.0
    var SEK: Double? = 1.0
    var SGD: Double? = 1.0
    var USD: Double? = 1.0
}
