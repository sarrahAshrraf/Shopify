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
    
    
    static let sharedLeagueDB = DatabaseManager()
    var arrayOfProducts: Array<LocalProduct>? = []
    var nsManagedLeagues : [NSManagedObject] = []
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

    
}
