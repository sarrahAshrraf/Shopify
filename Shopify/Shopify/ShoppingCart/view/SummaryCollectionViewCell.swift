//
//  SummaryCollectionViewCell.swift
//  Shopify
//
//  Created by sarrah ashraf on 17/06/2024.
//

import UIKit
import Kingfisher
class SummaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
        
        
        
    }

    
    
    func configure(cartItem: LineItems) {
        self.itemTitle.text = cartItem.name
        self.quantityLabel.text = "\(cartItem.quantity ?? 0)"
        if let priceString = cartItem.price, let price = Double(priceString) {
            let convertedPrice = price * currencyRate
            let formattedPrice = String(format: "%.2f", convertedPrice)
            self.priceLabel.text = "\(currencySymbol) \(formattedPrice)"
        } else {
            self.priceLabel.text = "\(currencySymbol) 0.00"
        }
        
        if let imageUrlString = cartItem.properties?.first?.value?.split(separator: "$").first {
            let imageUrl = String(imageUrlString)
            self.itemImg.kf.setImage(with: URL(string: imageUrl),
                                     placeholder: UIImage(named: Constants.noImage))
        } else {
            self.itemImg.image = UIImage(named: Constants.noImage)
        }
    }
}
