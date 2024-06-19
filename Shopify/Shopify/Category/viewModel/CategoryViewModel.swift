//
//  CategoryViewModel.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 08/06/2024.
//

import Foundation
class CategoryViewModel{
    var bindResultToViewController: (()->()) = {}
    
    var filteredProducts : [Product] = []{
        didSet {
            self.bindResultToViewController()
        }
    }
    var result: [Product] = [] {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    var product: Product? {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    
    func getItems(id: Int){
        let url = URLs.shared.getProductCategory(id: id)
        NetworkManger.shared.getData(url: url){ [weak self] (response: Response?) in
            self?.result = (response?.products)!
            self?.filteredProducts = (response?.products)!
        }
    }

    func getPrice(productId: Int, completion: @escaping (Product?) -> Void) {
        let url = URLs.shared.productDetails(id: productId)
        
        NetworkManger.shared.getData(url: url) { [weak self] (response: Response?) in
            guard let product = response?.product else {
                completion(nil)
                return
            }
            
            self?.product = product
            completion(product)
        }
    }


    func getAllProducts(){
        let url = URLs.shared.getAllProducts()
        NetworkManger.shared.getData(url: url) { [weak self] (response: Response?) in
            self?.result = (response?.products)!
            self?.filteredProducts = (response?.products)!
        }
    }
    
    
    
}
