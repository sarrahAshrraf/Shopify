//
//  AddNewAddressViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 08/06/2024.
//

import Foundation
class AddNewAddressViewModel{
    var fullName: String?
    var addressOne: String?
    var addressTwo: String?
    var city: String?
    var province: String?
    var country: String?
    
    init(address: Address?) {
        self.fullName = address?.name
        self.addressOne = address?.address1
        self.addressTwo = address?.address2
        self.city = address?.city
        self.province = address?.province
        self.country = address?.country
    }
}
