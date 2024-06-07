//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 07/06/2024.
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
        let path = ""
        NetworkManger().getData(url: path){ [weak self] (response: Response?) in
            self?.result = response?.smartCollections
//            print(self?.result)
//            print(self?.result?.count)
        }
    }
    
    
}
