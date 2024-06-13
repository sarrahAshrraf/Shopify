//
//  NetworkManger.swift
//  Shopify
//
//  Created by Ahmed Refat on 05/06/2024.
//

import Foundation
import Alamofire

class NetworkManger {
    
    static let shared = NetworkManger()

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
    
    func postData(path: String, parameters: Parameters,handler: @escaping (Response?,Int?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": "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"
        ]
        
        AF.request(path,method: .post,parameters: parameters,encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).responseData{ response in
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(Response.self, from: data)
                    handler(result,response.response?.statusCode)
                } catch {
                    print(error.localizedDescription)
                    return
                }
            case .failure(let error):
                print(error)
                handler(nil,error.responseCode)
            }
        }
    }
    
    func putData(path: String, parameters: Parameters, handler: @escaping (Response?, Int?) -> Void) {
           let headers: HTTPHeaders = [
               "Content-Type": "application/json",
               "X-Shopify-Access-Token": "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"
           ]
           
           AF.request(path, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).responseData { response in
               switch response.result {
               case .success(let data):
                   do {
                       let result = try JSONDecoder().decode(Response.self, from: data)
                       handler(result, response.response?.statusCode)
                   } catch {
                       print(error.localizedDescription)
                       return
                   }
               case .failure(let error):
                   print(error)
                   handler(nil, error.responseCode)
               }
           }
       }
    func deleteData(path: String, handler: @escaping (Bool, Int?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": "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"
        ]
        AF.request(path, method: .delete, headers: headers).validate(statusCode: 200 ..< 299).responseData { response in
            switch response.result {
            case .success:
                handler(true, response.response?.statusCode)
                print("suceed in network")
            case .failure(let error):
                print(error)
                print("error in network")

                handler(false, error.responseCode)
            }
        }
    }
    
    private init() {}
    
}

