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
        quantityLabel.layer.cornerRadius = 15
        layer.cornerRadius = 10
//        layer.cornerRadius = frame.size.width / 2.5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
//        itemImg.clipsToBounds = true
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        clipsToBounds = true
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowColor = UIColor.black.cgColor
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
