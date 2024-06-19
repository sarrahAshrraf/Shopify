//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 08/06/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    
   
    
    var product:Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
    }
    func setValues(product:Product) {
//        print("Success2")
        self.product = product
        self.productName.text = product.title ?? ""
        self.productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
                                      placeholder: UIImage(named: Constants.noImage))
//        if let variant = product.variants?.first {
//            if let price = Double(variant.price) {
//                let convertedPrice = price * currencyRate
//                self.productPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
//            }
//        }
    }
}
//        if product.variants?.count ?? 0 > 0{
//            print(product.variants![0].price)
//            self.productPrice.text = product.variants![0].price
//        }
//        if product.variants?.count ?? 0 > 0{
////            String(format: "%.1f", Double(product.variants![0].price)! *  Constants)
//
//            self.productPrice.text = String(format: "%.1f", Double(product.variants![0].price)! )
//        }
