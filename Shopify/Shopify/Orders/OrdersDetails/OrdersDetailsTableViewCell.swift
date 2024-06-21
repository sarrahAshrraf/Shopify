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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupCell()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupCell()
        }
        
        private func setupCell() {
            self.contentView.layer.cornerRadius = 10
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = UIColor.lightGray.cgColor
            self.contentView.layer.masksToBounds = true
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // Adjust the frame of the contentView
            self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
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
