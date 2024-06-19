//
//  SearchViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 19/06/2024.
//

import Foundation


class SearchViewModel {
    
    var bindResultToViewController: (()->()) = {}
   
    var result: [Product] = []  {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    
    func getItems(){
        
        let url = URLs.shared.allProduct()
        NetworkManger.shared.getData(url: url){ [weak self] (response : Response?) in
            self?.result = response?.products ?? []
        }
    }
    
}
