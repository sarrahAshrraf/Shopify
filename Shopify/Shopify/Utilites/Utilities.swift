//
//  Utilities.swift
//  Shopify
//
//  Created by sarrah ashraf on 18/06/2024.
//

import Foundation

class Utilities{
    static func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
}
