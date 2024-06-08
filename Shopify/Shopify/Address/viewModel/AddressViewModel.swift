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
        let url = ""
        
        NetworkManger.shared.getData(url: url) { response in
//            if let response = response {
//                self.addresses = response.addresses 
//                print("Fetched Addresses: \(response.addresses)")
//            } else {
//                print("Failed to fetch addresses")
//            }
        }
        
        func address(at index: Int) -> Address? {
             guard index >= 0 && index < addresses.count else {
                 return nil
             }
             return addresses[index]
         }
        
        func postNewAddress(){}
    }
}

