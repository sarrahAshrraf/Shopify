//
//  CartCell.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBAction func minusBtn(_ sender: Any) {
    }
    @IBAction func plusBtn(_ sender: Any) {
    }
    @IBAction func deleteBtn(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
