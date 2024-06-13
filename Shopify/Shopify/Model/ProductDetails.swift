//
//  ProductDetails.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import Foundation

class ProductDetails{
    var id:Int
    let name: String
    var price: String
    let description : String
    var imagesArray : [String]
    var quantity : Int
    init(brand:Product){
        id = brand.id ?? 0
        name = brand.title ?? "no name"
        price = brand.variants?.first?.price ?? "no price"
        quantity = brand.variants?.first?.inventoryQuantity ?? 1
        description = brand.bodyHtml ?? "no description"
        imagesArray = []
        for image in brand.images ?? [] {
            imagesArray.append(image.src!)
        }
    }
}
