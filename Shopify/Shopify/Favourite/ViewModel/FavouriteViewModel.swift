//
//  FavouriteViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 14/06/2024.
//

import Foundation
import Alamofire

class FavoritesViewModel{
    
    var bindallProductsListToController:(()->Void) = {}
    var bindGetFavoriteDraftOrderToController:(()->Void) = {}
    var bindResultToViewController: (()->()) = {}
    let defaults = UserDefaults.standard
    
    
    var result: [Product] = []  {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    var getFavoriteDraftOrder: DraftOrder?{
        didSet{
            bindGetFavoriteDraftOrderToController()
        }
    }
    var allProductsList = [LocalProduct](){
        didSet{
            bindallProductsListToController()
        }
    }
    
    
    
    func addProduct(product: LocalProduct) {
        DatabaseManager.sharedProductDB.insertProduct(product: product)
    }
    
    func removeProduct(id : Int ) {

        DatabaseManager.sharedProductDB.delete(id: id)
    }
    
    func getAllProducts() {
        allProductsList = DatabaseManager.sharedProductDB.fetchAllProducts()!
        print(allProductsList)
        FavouriteViewController.staticFavoriteList = allProductsList
    }
    
    func removeAllProduct(){
        DatabaseManager.sharedProductDB.deleteAll()
    }
    
    func checkIfProductIsFavorite(productId: Int, customerId: Int) -> Bool {
        return DatabaseManager.sharedProductDB.isFavorite(productId: productId,customerId: customerId)
    }
    
    func getProduct(productId: Int) -> LocalProduct {
        return DatabaseManager.sharedProductDB.fetchProduct(productId: productId)
    }
    
    func getRemoteProducts(){
        
        let url = URLs.shared.allProduct()
        NetworkManger.shared.getData(url: url){ [weak self] (response : Response?) in
            self?.result = response?.products ?? []
        }
    }
    
    
    func getFavoriteDraftOrderFromAPI(){
        let url = URLs.shared.favouriteDraftOrder()
        NetworkManger.shared.getData(url: url) { [weak self] response in
            self?.getFavoriteDraftOrder = response?.draft_order
            
        }
    }
}
