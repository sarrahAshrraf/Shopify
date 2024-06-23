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
}
