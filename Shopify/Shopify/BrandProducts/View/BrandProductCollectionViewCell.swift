//
//  BrandProductCollectionViewCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit
import Kingfisher

class BrandProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    var product:Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(product:Product) {
        print("Success2")
        self.product = product
        self.productLabel.text = product.title ?? ""
        self.productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
                                      placeholder: UIImage(named: Constants.noImage))
        if product.variants?.count ?? 0 > 0{
            
            self.productPrice.text = product.variants![0].price
        }
    }

}
