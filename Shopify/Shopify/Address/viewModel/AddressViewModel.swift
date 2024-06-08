//
//  AddressViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import Foundation
class AddressViewModel{
    var bindToVC : ()->() = {}
    //    var customers: [Customer] = [] {
    //        didSet{
    //          bindToVC()
    //        }
    //      }
    var addresses: [Address] = [] {
        didSet{
            bindToVC()
        }
    }
    
    func fetchCustomerAddress(customerID: Int) {
//        let url = "https://349c94c1c855b8b029a39104a4ae2e13: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@mad44-alx-ios-team1.myshopify.com/admin/api/2024-01/customers/\(7309504250029)/addresses.json?limit=4"
        let url = URLs.shared.getAddressURL()
        NetworkManger.shared.getData(url: url) { response in
            if let response = response {
                self.addresses = response.addresses ?? []
                print("Fetched Addresses: \(response.addresses)")
            } else {
                print("Failed to fetch addresses")
            }
        }
        
//        func address(at index: Int) -> Address? {
//             guard index >= 0 && index < addresses.count else {
//                 return nil
//             }
//             return addresses[index]
//         }
        
        func postNewAddress(){}
    }
}

