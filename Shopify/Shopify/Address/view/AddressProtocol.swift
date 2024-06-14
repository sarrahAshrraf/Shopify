//
//  AddressProtocol.swift
//  Shopify
//
//  Created by sarrah ashraf on 09/06/2024.
//

import Foundation
protocol AddressProtocol: AnyObject {
    func didUpdateAddress()
}
protocol AddressSelectionDelegate: AnyObject {
    func didSelectAddress(_ address: Address)
}
