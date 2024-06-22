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
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
        setCurrency()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataToTableCell(product: LocalProduct) {
        self.localProduct = product
        productImageView.kf.setImage(with: URL(string: localProduct.image))
        productNameLabel.text = Splitter().splitName(text: localProduct.title, delimiter: "| ")
        productBrandLabel.text = Splitter().splitBrand(text: localProduct.title, delimiter: "| ")
        let price = Int((Double(localProduct.price ) ?? 0.0)*currencyRate)
        productPriceLabel.text = String(price)
        curencyLabel.text = currencySymbol
    }
    
    func setProductToTableCell(product: Product) {
        self.product = product
        
        productBrandLabel.text = Splitter().splitBrand(text: product.title ?? "", delimiter: "| ")
        productImageView.kf.setImage(with: URL(string: product.image?.src ?? ""))
        productNameLabel.text = Splitter().splitName(text: product.title ?? "", delimiter: "| ")
        let price = Int((Double((product.variants?[0].price)! ) ?? 0.0)*currencyRate)
        productPriceLabel.text = String(price)
        curencyLabel.text = currencySymbol
    
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
    
    func setCurrency(){
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) ?? "USD"
            currencySymbol = symbol
    }
    
}
