//
//  NetworkManger.swift
//  Shopify
//
//  Created by Ahmed Refat on 05/06/2024.
//

import Foundation
import Alamofire

class NetworkManger {
    
    
    func getData(url: String,handler: @escaping (Response?) -> Void) {
        AF.request(url,parameters: nil, headers: nil).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let data):
                handler(data)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

