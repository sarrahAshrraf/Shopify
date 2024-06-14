//
//  CheckOutViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import Foundation
class CheckOutViewModel{

    var bindOrderToViewController: (()->()) = {}
    var code: Int?
    var generalViewModel = ShoppingCartViewModel()

    var order: Orders?{
        didSet{
            self.bindOrderToViewController()
            
        }
    }
    
    func postOrder(order: Orders) {
        let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: nil, orders: nil, order: order)
        
        guard let params = JSONCoding().encodeToJson(objectClass: response) else {
            print("Failed to encode JSON")
            return
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON Payload: \(jsonString)")
        }

        NetworkManger.shared.postData(path: URLs.shared.postOrderURL(), parameters: params) { [weak self] (response, code) in
            self?.order = response?.order
            self?.code = code
            print("INSEIIIID ORDER POSTINGGGG")
            print(response?.order)
            
            if let code = code, code != 200 {
                print("HTTP Status Code: \(code)")
            }
        }
    }
    
//    func postOrder(order: Orders) {
//        let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: nil, orders: nil, order: order)
//        
//        let params = JSONCoding().encodeToJson(objectClass: response)
//        NetworkManger.shared.postData(path: URLs.shared.postOrderURL() ,parameters: params ?? [:]) { [weak self] (response, code) in
//            self?.order = response?.order
//            self?.code = code
//            print("INSEIIIID ORDER POSTINGGGG")
//            print(response?.order)
//        }
//    }
    
    func updateVariantAfterPostOrder(){
        let items = CartList.cartItems
        let url = "inventory_levels/set"
        for item in items {
            var inventoryItemId = (item.properties?[0].value?.split(separator: "$")[1])!
            var stockCount = Int(item.properties?[0].name ?? "1") ?? 1
            print("inv ID \(inventoryItemId) ++++++++++ \(stockCount)")
            let inventoryLevel = InventoryLevel(inventoryItemId: Int(inventoryItemId), locationId: 83976225055, available: (stockCount - item.quantity!))
            NetworkManger.shared.postData(path: url, parameters: JSONCoding().encodeToJsonFromInvLevel(objectClass: inventoryLevel)!) {[weak self] response, code in
           }
        }
    }
}


    
    
    

