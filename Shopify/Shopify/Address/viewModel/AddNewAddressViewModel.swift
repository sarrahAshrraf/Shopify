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
    
    required init(address: Address?) {
        self.fullName = address?.name
        self.addressOne = address?.address1
        self.addressTwo = address?.address2
        self.city = address?.city
        self.province = address?.province
        self.country = address?.country
    }
    init(){}
    
    
    func postCustomerAddress(customerID: Int, address: Address, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: "https://mad44-alx-ios-team1.myshopify.com/admin/api/2024-01/customers/\(7309504250029)/addresses.json") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")
        
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
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: finalDict, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to serialize JSON: \(error)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to post address: \(error)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No response from server")
                completion(false)
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Success response from server")
                completion(true)
            } else {
                print("Invalid response from server")
                if let data = data {
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "No response data")")
                }
                completion(false)
            }
        }
        
        task.resume()
    }
}
