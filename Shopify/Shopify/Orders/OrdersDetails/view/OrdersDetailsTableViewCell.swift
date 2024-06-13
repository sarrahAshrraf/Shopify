//
//  OrdersDetailsTableViewCell.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 13/06/2024.
//

import UIKit

class OrdersDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var orderProductName: UILabel!
    
    @IBOutlet weak var orderProductQuntity: UILabel!
    
    
    @IBOutlet weak var orderProductPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
