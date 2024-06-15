//
//  ProductCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 14/06/2024.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

    @IBOutlet weak var curencyLabel: UILabel!
    
    var localProduct: LocalProduct!
    var product: Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataToTableCell(product: LocalProduct) {
        self.localProduct = product
        productImageView.kf.setImage(with: URL(string: localProduct.image))
        productNameLabel.text = localProduct.title
        productPriceLabel.text = localProduct.price 
    }
    
}
