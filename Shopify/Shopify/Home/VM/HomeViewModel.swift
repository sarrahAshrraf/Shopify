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
        let url = URLs.shared.getBrandsURL()
        NetworkManger.shared.getData(url: url){ [weak self] (response: Response?) in
            self?.result = response?.smart_collections
        }
    }
    
    
}
