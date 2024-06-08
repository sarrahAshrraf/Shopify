//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import Foundation

class ProductDetailsViewModel {
    
    var productId:Int = 0
    var bindResultToViewController: (()->()) = {}
    var result: Product? {
        didSet{
            self.bindResultToViewController()
        }
    }
   
    func getItems(){

        let url = URLs.shared.productDetails(id: productId)
        
        NetworkManger.shared.getData(url: url){ [weak self] (response : Response?) in
            self?.result = (response?.product)!
            print(self?.result)
        }
    }
}

