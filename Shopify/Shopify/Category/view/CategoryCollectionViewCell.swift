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
    
    var price = 0.0
    
    var product:Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValues(product:Product) {
//        print("Success2")
        self.product = product
        self.productName.text = product.title ?? ""
        self.productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
                                      placeholder: UIImage(named: Constants.noImage))
        
        
        
//        if product.variants?.count ?? 0 > 0{
//            print(product.variants![0].price)
//            self.productPrice.text = product.variants![0].price
//        }
        if product.variants?.count ?? 0 > 0{
            
            self.productPrice.text = String(format: "%.1f", Double(product.variants![0].price)! )
        }
    }
}
