//
//  AddressCell.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit
//9-6:
//set as deafult
//edit addresss
//reload table view
//delete address
//scroll view
class AddressCell: UITableViewCell {
    
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var deafultLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with addresses: Address, indexPath: Int) {
        addressLabel.text = addresses.address1
        countryLabel.text = addresses.country
        fullNameLabel.text = addresses.first_name
        if addresses.default == true {
            locationImg.image = UIImage(systemName: "pin.circle.fill")
            deafultLabel.isHidden = false
            } else {
                locationImg.image = UIImage(systemName: "pin.circle")
                deafultLabel.isHidden = true
            }
    }
    private func configureShadow() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}
