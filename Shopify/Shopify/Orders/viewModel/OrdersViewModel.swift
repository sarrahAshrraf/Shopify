//
//  OrdersViewModel.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 12/06/2024.
//

import Foundation
class OrdersViewModel {
    
    
    var bindOrdersToViewController: (()->()) = {}
    
    var result: [Orders]? = [] {
        didSet{
            self.bindOrdersToViewController()
        }
    }
    
    var filteredOrder: [Orders]? = []{
        didSet{
            self.bindOrdersToViewController()
        }
    }
    
    func getOrders(){
        print("getOrdersFunc")
        let url = URLs.shared.getOrders() + "?status=any"
        NetworkManger.shared.getData(url: url){ [weak self] (response : Response?) in
            
            self?.result = response?.orders
            self?.filteredOrder = response?.orders
            print(self?.result?.count ?? 0)
        }
    }
}

