//
//  Splitter.swift
//  Shopify
//
//  Created by Ahmed Refat on 19/06/2024.
//

import Foundation


class Splitter {
    
    func splitName(text: String, delimiter: String ) -> String{
        let substrings = text.components(separatedBy: delimiter)
        return substrings[substrings.count-1]
    }
    
    func splitBrand(text: String, delimiter: String ) -> String{
        let substrings = text.components(separatedBy: delimiter)
           return substrings.first ?? ""
    }
}
