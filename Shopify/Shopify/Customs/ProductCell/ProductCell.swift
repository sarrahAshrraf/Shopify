//
//  ProductCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 14/06/2024.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

    @IBOutlet weak var curencyLabel: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    
    var localProduct: LocalProduct!
    var product: Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataToTableCell(product: LocalProduct) {
        self.localProduct = product
        productImageView.kf.setImage(with: URL(string: localProduct.image))
        productNameLabel.text = localProduct.title
        productPriceLabel.text = localProduct.price 
    }
    
    func setProductToTableCell(product: Product) {
        self.product = product
        productImageView.kf.setImage(with: URL(string: product.image?.src ?? ""))
        productNameLabel.text = Splitter().splitName(text: product.title ?? "", delimiter: "| ")
        productPriceLabel.text = product.variants?[0].price ?? ""
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
