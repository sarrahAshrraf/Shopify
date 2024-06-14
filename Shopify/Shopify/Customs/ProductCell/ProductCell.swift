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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
