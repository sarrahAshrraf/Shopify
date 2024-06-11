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
    func getCartItems(){
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
}
