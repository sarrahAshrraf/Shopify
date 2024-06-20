//
//  CustomTableViewCell.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 01/06/2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    
    @IBOutlet weak var orderName: UILabel!
    
    @IBOutlet weak var numOfItems: UILabel!
    
    @IBOutlet weak var orderPrice: UILabel!
    
    @IBOutlet weak var orderStatus: UILabel!
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setOrderValues(order: Orders) {
        self.orderName.text = order.name
        
        if let createdAtString = order.customer?.createdAt {
            self.numOfItems.text = Utilities.formatDateString(createdAtString)
        }
        
        if let priceString = order.totalPrice, let price = Double(priceString), let orderCurrency = order.currency {
                   let currencyRate: Double
                   let currencySymbol: String

                   switch orderCurrency {
                   case "EGP":
                       currencyRate = 47.707102
                       currencySymbol = "EGP"
                   case "USD":
                       currencyRate = 1.0
                       currencySymbol = "USD"
                   case "EUR":
                       currencyRate =  0.934102
                       currencySymbol = "EUR"
                   default:
                       currencyRate = 1.0
                       currencySymbol = orderCurrency
                   }
                   
                   let convertedPrice = price * currencyRate
                   self.orderPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
               } else {
                   self.orderPrice.text = order.totalPrice
               }
               
               self.orderStatus.text = order.financialStatus
           }
}



//Rate for EGP: 47.707102
//Rate for USD: 1.0
//Rate for EUR: 0.934102
