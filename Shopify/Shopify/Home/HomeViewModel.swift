//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 06/06/2024.
//

import Foundation
class HomeViewModel {
    var bindResultToViewController: (()->()) = {}
    var result: [SmartCollections]? = [] {
        didSet{
            self.bindResultToViewController()
            
        }
    }
    func getItems(){
       
        NetworkManger().getData(url: path){ [weak self] (response: Response?) in
            self?.result = response?.smart_collections
//            print(self?.result)
//            print(self?.result?.count)
        }
    }
    
    
}
