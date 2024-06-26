//
//  BrandProductsViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import Foundation
import Alamofire


class BrandProductsViewModel{
//    var brandId:Int = 306236260525
    var brandId:Int = 0
    var bindResultToViewController: (()->()) = {}
    var result: [Product] = []  {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    
    func getItems(){
        let url = URLs.shared.brandProductsURL(id: brandId)
        NetworkManger.shared.getData(url: url){ [weak self] (response : Response?) in
            self?.result = (response?.products)!
            print(self?.result.count)
        }
    }

    
}

