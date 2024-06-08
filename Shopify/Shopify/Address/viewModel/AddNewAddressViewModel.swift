//
//  AddNewAddressViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 08/06/2024.
//

import Foundation
import Alamofire
class AddNewAddressViewModel{
    var fullName: String?
    var addressOne: String?
    var addressTwo: String?
    var city: String?
    var province: String?
    var country: String?
    
    required init(address: Address?) {
        self.fullName = address?.name ?? ""
              self.addressOne = address?.address1 ?? ""
              self.addressTwo = address?.address2 ?? ""
              self.city = address?.city ?? ""
              self.province = address?.province ?? ""
              self.country = address?.country ?? ""
    }
    init(){}
    func postCustomerAddress(customerID: Int, address: Address, completion: @escaping (Bool) -> ()) {
            let url = "https://mad44-alx-ios-team1.myshopify.com/admin/api/2024-01/customers/\(customerID)/addresses.json"
            
            let addressDict: [String: Any] = [
                "address1": address.address1 ?? "",
                "address2": address.address2 ?? "",
                "city": address.city ?? "",
                "company": address.company ?? "",
                "first_name": address.first_name ?? "",
                "last_name": address.last_name ?? "",
                "phone": address.phone ?? "",
                "province": address.province ?? "",
                "country": address.country ?? "",
                "zip": address.zip ?? "",
                "name": address.name ?? "",
                "province_code": address.province_code ?? "",
                "country_code": address.country_code ?? "",
                "country_name": address.country_name ?? "",
                "default": address.default ?? false
            ]
            
            let finalDict: [String: Any] = ["address": addressDict]
            
            NetworkManger.shared.postData(path: url, parameters: finalDict) { response, statusCode in
                if let statusCode = statusCode, (200...299).contains(statusCode) {
                    print("HTTP Status Code: \(statusCode)")
                    print("Success response from server")
                    completion(true)
                } else {
                    print("Invalid response from server")
                    if let response = response {
                        print("Response data: \(response)")
                    }
                    completion(false)
                }
            }
        }
    }

