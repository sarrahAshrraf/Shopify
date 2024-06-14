//
//  CustomTableViewCell.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 01/06/2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    

    @IBOutlet weak var orderName: UILabel!
    
    @IBOutlet weak var numOfItems: UILabel!
    
    @IBOutlet weak var orderPrice: UILabel!
    
    @IBOutlet weak var orderStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrderValues(order: Orders){
        self.orderName.text = order.name
        self.numOfItems.text = order.customer?.createdAt
        self.orderPrice.text = order.totalPrice
        
        self.orderStatus.text = order.financialStatus
    }
    
}
