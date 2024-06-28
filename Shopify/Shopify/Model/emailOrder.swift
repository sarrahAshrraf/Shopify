//
//  OrderEmail.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 26/06/2024.
//

import Foundation
struct DraftOrderInvoice: Codable {
    let to: String
    let from: String
    let subject: String
    let customMessage: String
    let bcc: [String]

    // Custom coding keys to match the JSON keys
    enum CodingKeys: String, CodingKey {
        case to
        case from
        case subject
        case customMessage = "custom_message"
        case bcc
    }
    
    init(to: String, from: String, subject: String, customMessage: String, bcc: [String]) {
        self.to = to
        self.from = from
        self.subject = subject
        self.customMessage = customMessage
        self.bcc = bcc
    }
}

