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
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var orderProductImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
