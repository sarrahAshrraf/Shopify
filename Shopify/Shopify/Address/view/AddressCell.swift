//
//  AddressCell.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with addresses: Address, indexPath: Int) {
        addressLabel.text = addresses.address1
        countryLabel.text = addresses.country
        fullNameLabel.text = addresses.firstName

    }
}
