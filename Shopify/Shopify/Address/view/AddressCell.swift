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
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var deafultLabel: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureContainerView()
        //configureShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with addresses: Address, indexPath: Int) {
        addressLabel.text = addresses.address1
        phoneLabel.text = "Phone: \(String(addresses.phone ?? ""))"
        fullNameLabel.text = "Name: \(String(addresses.first_name ?? ""))"
        if addresses.default == true {
            //locationImg.image = UIImage(systemName: "pin.circle.fill")
            deafultLabel.isHidden = false
            } else {
                //locationImg.image = UIImage(systemName: "pin.circle")
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
    
    private func configureContainerView() {
        containerView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        containerView.isLayoutMarginsRelativeArrangement = true
        
        // Adding a custom view to the container with shadow
        containerView.backgroundColor = UIColor(named: "CardColor")
        containerView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
    }
}
