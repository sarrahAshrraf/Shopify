//
//  DatabaseManager.swift
//  Shopify
//
//  Created by Ahmed Refat on 14/06/2024.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    
    static let sharedProductDB = DatabaseManager()
    var arrayOfProducts: Array<LocalProduct> = []
    var nsManagedProducts : [NSManagedObject] = []
    let manager : NSManagedObjectContext!
    let entity: NSEntityDescription!
    
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = appDelegate.persistentContainer.viewContext
        
        entity = NSEntityDescription.entity(forEntityName: "FavouriteProduct", in: manager)
    }
    
    
    func insertProduct(product: LocalProduct){
      
        let favProduct = NSManagedObject(entity: entity!, insertInto: manager)
      
        favProduct.setValue(product.id, forKey: "id")
        favProduct.setValue(product.customer_id, forKey: "customer_id")
        favProduct.setValue(product.image, forKey: "image")
        favProduct.setValue(product.price, forKey: "price")
        favProduct.setValue(product.variant_id, forKey: "variant_id")
        favProduct.setValue(product.title, forKey: "title")
        do {
            try manager.save()
            print("saved")
        } catch let error as NSError{
            print(error)
        }
    }
    
    func fetchAllProducts() -> Array<LocalProduct>? {
        arrayOfProducts = []
      
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteProduct")
        do{
            nsManagedProducts = try manager.fetch(fetchRequest)
            
            for product in nsManagedProducts{
                var productObj = LocalProduct(id: 0, customer_id: 0, variant_id: 0, title: "", price: "", image: "")
                productObj.id = product.value(forKey: "id") as! Int
                productObj.customer_id = product.value(forKey: "customer_id") as! Int
                productObj.variant_id = product.value(forKey: "variant_id") as! Int
                productObj.title = product.value(forKey: "title") as! String
                productObj.price = product.value(forKey: "price") as! String
                productObj.image = product.value(forKey: "image") as! String
                arrayOfProducts.append(productObj)
            }
            return  arrayOfProducts
            
        } catch let error as NSError{
              print(error)
              return []
          }
    }
    
    func fetchProduct(productId: Int) -> LocalProduct {
        let allProductsList = fetchAllProducts()
        var productObj: LocalProduct!
        for product in allProductsList! {
            if(product.id == productId) {
                productObj = product
                break
            }
        }
        return productObj
    }
    
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteProduct")
        do{
            nsManagedProducts = try
            manager.fetch(fetchRequest)
        }
        catch let error as NSError{
            print(error)
        }
        
        for element in nsManagedProducts{
            manager.delete(element)
        }
        do{
            try manager.save()
            print("Deleted!")
        }catch let error{
            print(error.localizedDescription)
        }
    }

    func delete(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteProduct")
        do {
            nsManagedProducts = try manager.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            return
        }
        
        for element in nsManagedProducts {
            if let deletedID = element.value(forKey: "id") as? Int, deletedID == id {
                manager.delete(element)
            }
        }
        
        do {
            try manager.save()
            print("Deleted!")
            arrayOfProducts = arrayOfProducts.filter { $0.id != id } // Update arrayOfProducts
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func isFavorite(productId: Int, customerId: Int) -> Bool {
        let allProductsList = fetchAllProducts()
        for product in allProductsList! {
            if(product.id == productId && product.customer_id == customerId) {
                return true
            }
        }
        return false
    }
    

    
}
