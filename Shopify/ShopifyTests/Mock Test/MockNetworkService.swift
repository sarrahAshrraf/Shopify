//
//  MockNetworkService.swift
//  ShopifyTests
//
//  Created by Mohamed Kotb Saied Kotb on 23/06/2024.
//

import Foundation
@testable import Shopify
class MockNetworkService {
    
    var result = SmartCollections(id: 0, handle: "", title: "", updatedAt: "", bodyHtml: "", publishedAt: "", sortOrder: "", disjunctive: false, rules: [Rules(column: "", relation: "", condition: "")], publishedScope: "", adminGraphqlApiId: "", image: Image(id: 0, productId: 0, position: 0, createdAt: "", updatedAt: "", width: 0, height: 0, src: "", adminGraphqlApiId: ""))
    
    
    var myAdress = Address(id: 0, customer_id: 0, name: "", first_name: "", last_name: "", phone: "", company: "", address1: "", address2: "", city: "", province: "", country: "", zip: "", province_code: "", country_code: "", country_name: "")
    // true = error, false = no error
    var flag: Bool
    
    init(flag: Bool) {
        self.flag = flag
    }
    
    let fakeJSONObj: [String: Any] = [
        "smart_collections": [
            [
                "id": 448683835677,
                "handle": "adidas",
                "title": "ADIDAS",
                "updated_at": "2023-05-31T09:46:13-04:00",
                "body_html": "Adidas collection",
                "published_at": "2023-05-31T09:39:41-04:00",
                "sort_order": "best-selling",
                "template_suffix": NSNull(),
                "disjunctive": false,
                "rules": [
                    [
                        "column": "title",
                        "relation": "contains",
                        "condition": "ADIDAS"
                    ]
                ],
                "published_scope": "web",
                "admin_graphql_api_id": "gid://shopify/Collection/448683835677",
                "image": [
                    "created_at": "2023-05-31T09:39:41-04:00",
                    "alt": NSNull(),
                    "width": 1000,
                    "height": 676,
                    "src": "https://cdn.shopify.com/s/files/1/0764/8906/4733/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1685540381"
                ]
            ]
        ]
    ]
    
    
    let fakeJSONObjAddress: [String: Any] = [
        "addresses": [
            [
                "id": 9279432491293,
                "customer_id": 7023980937501,
                "first_name": "testUser",
                "last_name": NSNull(),
                "company": NSNull(),
                "address1": "13 louran",
                "address2": NSNull(),
                "city": "alex",
                "province": NSNull(),
                "country": "Egypt",
                "zip": NSNull(),
                "phone": "01256854138",
                "name": "testUser",
                "province_code": NSNull(),
                "country_code": "EG",
                "country_name": "Egypt",
                "default": false
            ],
            [
                "id": 9279433310493,
                "customer_id": 7023980937501,
                "first_name": "testUser",
                "last_name": NSNull(),
                "company": NSNull(),
                "address1": "13",
                "address2": NSNull(),
                "city": "Dubai",
                "province": NSNull(),
                "country": "United Arab Emirates",
                "zip": NSNull(),
                "phone": "01875421828",
                "name": "testUser",
                "province_code": NSNull(),
                "country_code": "AE",
                "country_name": "United Arab Emirates",
                "default": true
            ]
        ]
    ]


}


extension MockNetworkService {
    enum ResponseWithError: Error {
        case responseError
    }
    
    func fetchData(completionHandler: @escaping (SmartCollections?, Error?) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeJSONObj)
            result = try JSONDecoder().decode(SmartCollections.self, from: data)
            
            if flag {
                completionHandler(nil, ResponseWithError.responseError)
            } else {
                completionHandler(result, nil)
            }
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func postData(completionHandler: @escaping (Addresses?, Error?) -> Void) {
        // Define the URL to which data will be posted
        let path = URLs.shared.getAddressURL(customerId: "7309504250029")
        guard let url = URL(string: path) else {
            completionHandler(nil, URLError(.badURL))
            return
        }
        
        // Create a URLRequest and set its HTTP method to POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the fakeJSONObj into JSON data
        do {
            let fakeJSONObj: [String: Any] = [
                "addresses": [
                    [
                        "id": 9279432491293,
                        "customer_id": 7023980937501,
                        "first_name": "testUser",
                        "last_name": NSNull(),
                        "company": NSNull(),
                        "address1": "13 louran",
                        "address2": NSNull(),
                        "city": "alex",
                        "province": NSNull(),
                        "country": "Egypt",
                        "zip": NSNull(),
                        "phone": "01256854138",
                        "name": "testUser",
                        "province_code": NSNull(),
                        "country_code": "EG",
                        "country_name": "Egypt",
                        "default": false
                    ],
                    [
                        "id": 9279433310493,
                        "customer_id": 7023980937501,
                        "first_name": "testUser",
                        "last_name": NSNull(),
                        "company": NSNull(),
                        "address1": "13",
                        "address2": NSNull(),
                        "city": "Dubai",
                        "province": NSNull(),
                        "country": "United Arab Emirates",
                        "zip": NSNull(),
                        "phone": "01875421828",
                        "name": "testUser",
                        "province_code": NSNull(),
                        "country_code": "AE",
                        "country_name": "United Arab Emirates",
                        "default": true
                    ]
                ]
            ]
            
            let data = try JSONSerialization.data(withJSONObject: fakeJSONObj)
            request.httpBody = data
        } catch {
            completionHandler(nil, error)
            return
        }
        
        // Create a URLSession data task to post the data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionHandler(nil, ResponseWithError.responseError)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, ResponseWithError.responseError)
                return
            }
            
            do {
                // Decode the response data into Addresses
                let result = try JSONDecoder().decode(Addresses.self, from: data)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        
        // Start the data task
        task.resume()
    }
}
    struct Addresses: Codable {
        let addresses: [Address]
    }
