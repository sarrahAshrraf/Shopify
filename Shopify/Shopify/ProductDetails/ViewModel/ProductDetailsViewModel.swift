//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import Foundation

class ProductDetailsViewModel {
    
    var productId:Int = 7748774527149
    var bindResultToViewController: (()->()) = {}
    var result: ProductDetails? {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    
}

