//
//  ShoppingCartViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import Foundation
class ShoppingCartViewModel{
    var bindResultToViewController: (()->()) = {}
    var result: DraftOrder?  {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    
    func showCartItems(){
        let url = URLs.shared.getCartItems(cartId: 945806409901)
        NetworkManger.shared.getData(url: url) { response in
            if let response = response {
                self.result = (response.draft_order)!
                print("Fetched cart: \(response.draft_order)")
            } else {
                print("Failed to fetch cart")
            }
            
        }
        
    }
    
    
    func editCart(){
        print("Cart Items: \(CartList.cartItems)")

        let draftOrder = DraftOrder(id: nil, note: nil, line_items: CartList.cartItems)
        let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: draftOrder)
        guard let params = JSONCoding().encodeToJson(objectClass: response) else {
            print("Failed to encode JSON")
            return
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON Payload: \(jsonString)")
        }

        NetworkManger.shared.putData(path: URLs.shared.getCartItems(cartId: 945806409901), parameters: params) { response, code in
            if let response = response {
                print("Draft order updated successfully: \(response)")
            } else {
                print("Failed to update draft order, status code: \(String(describing: code))")
            }
        }
    }

    
    
    
    func getCartItems() {
        let url = URLs.shared.getCartItems(cartId: 945806409901)
        NetworkManger.shared.getData(url: url) { response in
            if var lineItems = response?.draft_order?.line_items {
                for (index, lineItem) in lineItems.enumerated() {
                    if lineItem.title == "dummy" {
                        lineItems.remove(at: index)
                        break
                    }
                }
                CartList.cartItems = lineItems
                self.result = response?.draft_order
            } else {
                print("Failed to retrieve draft order or line items")
            }
        }
    }
}

class JSONCoding{
    func encodeToJson(objectClass: Response) -> [String: Any]?{
        do{
            let jsonData = try JSONEncoder().encode(objectClass)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonToDictionary(from: json)
        }catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func encodeToJsonFromInvLevel(objectClass: InventoryLevel) -> [String: Any]?{
        do{
            let jsonData = try JSONEncoder().encode(objectClass)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonToDictionary(from: json)
        }catch let error{
            print(error.localizedDescription)
            return nil
        }
    }

    func jsonToDictionary(from text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String : Any]
    }
}

