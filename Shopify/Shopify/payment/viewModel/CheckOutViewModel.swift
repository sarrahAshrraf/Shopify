//
//  CheckOutViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import Foundation
class CheckOutViewModel{
//bind failure + loocation id?
    var bindOrderToViewController: (()->()) = {}
//    var bindFailureToViewController: (()->()) = {} TODDDDDOOOO

    var code: Int?
    var generalViewModel = ShoppingCartViewModel()
    
    var order: Orders?{
        didSet{
            self.bindOrderToViewController()
            
        }
    }
//    TODO: shiiping addddddressssssss
    func postOrder(order: Orders) {
        let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: nil, orders: nil, order: order, currencies: nil, base: nil, rates: nil)
        
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
//                self?.bindFailureToViewController()
                        } else {
                            self?.bindOrderToViewController()
                        }
        }
    }
    
    
    func updateVariantAfterPostOrder(){
        let items = CartList.cartItems
        for item in items {
            var inventoryItemId = (item.properties?[0].value?.split(separator: "$")[1])!
            var stockCount = Int(item.properties?[0].name ?? "1") ?? 1
            let inventoryLevel = InventoryLevel(inventoryItemId: Int(inventoryItemId), locationId: 0000000, available: (stockCount - item.quantity!))
            NetworkManger.shared.postData(path: URLs.shared.postInventoryURL(), parameters: JSONCoding().encodeToJsonFromInvLevel(objectClass: inventoryLevel)!) {[weak self] response, code in
                if let code = code {
                                    if code == 200 {
                                        print("Inventory updated successfully for item ID: \(inventoryItemId)")
                                    } else {
                                        print("Failed to update inventory for item ID: \(inventoryItemId). HTTP Status Code: \(code)")
                                    }
                                }
                            }
                        }
                    }
    
    func emptyCart(){}
}


    
    
    

