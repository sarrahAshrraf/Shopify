//
//  CategoryViewModel.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 08/06/2024.
//

import Foundation
class CategoryViewModel{
    var bindResultToViewController: (()->()) = {}
    
    var result: [Product] = [] {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    
    func getItems(id: Int){
        let url = URLs.shared.getProductCategory(id: id)
        NetworkManger.shared.getData(url: url){ [weak self] (response: Response?) in
            self?.result = (response?.products)!
        }
    }
    
    
}
