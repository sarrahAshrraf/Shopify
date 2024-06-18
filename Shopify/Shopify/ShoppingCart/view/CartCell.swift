//
//  CartCell.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit
import Kingfisher
protocol CartCellDelegate: AnyObject {
    func deleteItem(_ cell: CartCell)
    // func updateCartPrice()
}

class CartCell: UITableViewCell {
    var viewController: CartViewController?
    weak var delegate: CartCellDelegate?
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    var totalAvailableVariantInStock: Int = 0
    var productCount = 1
    var itemInCart: LineItems!
    var viewModel = ShoppingCartViewModel()

    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    @IBAction func minusBtn(_ sender: Any) {
        if productCount > 1 {
            updateQuantity(by: -1)
        }
    }

    @IBAction func plusBtn(_ sender: Any) {
        if canIncreaseQuantity() {
            updateQuantity(by: 1)
        }
    }

    @IBAction func deleteBtn(_ sender: Any) {
        delegate?.deleteItem(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with item: [LineItems], index: Int) {
        titleLabel.text = item[index].name
        priceLabel.text = item[index].price
        print(item[index].name)
    }

    func setCartItemValues(lineItem: LineItems, viewController: CartViewController) {
        let imageUrl = (lineItem.properties?[0].value?.split(separator: "$")[0])!
        self.itemImg.kf.setImage(with: URL(string: String(imageUrl)), placeholder: UIImage(named: "noImage"))
        self.titleLabel.text = lineItem.name
        self.brandLabel.text = "\(lineItem.vendor ?? "") / \((lineItem.variantTitle) ?? "")"

        if let priceString = lineItem.price, let price = Double(priceString) {
            let convertedPrice = price * currencyRate
            self.priceLabel.text = "\(currencySymbol) \(String(format: "%.2f", convertedPrice))"
        } else {
            self.priceLabel.text = "\(currencySymbol) 0.00"
        }

        self.quantityLabel.text = "\((lineItem.quantity) ?? 0)"
        productCount = lineItem.quantity ?? 0
        totalAvailableVariantInStock = Int(lineItem.properties?[0].name ?? "1") ?? 1

        self.viewController = viewController
        self.itemInCart = lineItem
        updateButtonStates()
    }

    func updateQuantity(by amount: Int) {
        guard let itemPrice = Double(itemInCart.price!) else { return }

        viewController?.cartPrice -= Double(productCount) * itemPrice * currencyRate
        productCount += amount
        viewController?.cartPrice += Double(productCount) * itemPrice * currencyRate
        quantityLabel.text = "\(productCount)"
        updateShoppingListItemsCount()
        updateButtonStates()
    }

    func canIncreaseQuantity() -> Bool {
        return totalAvailableVariantInStock > 3 && productCount < totalAvailableVariantInStock / 3 ||
            totalAvailableVariantInStock <= 3 && productCount < totalAvailableVariantInStock
    }

    func updateButtonStates() {
        minusBtn.isEnabled = productCount > 1
        plusBtn.isEnabled = canIncreaseQuantity()
    }

    func updateShoppingListItemsCount() {
        for (index, item) in CartList.cartItems.enumerated() {
            if item.variantId == itemInCart.variantId {
                CartList.cartItems[index].quantity = productCount
            }
        }
        viewModel.editCart()
    }

    private func setupCell() {
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 4.1)
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .white

        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
    }
}
class CartList{
    static var cartItems: [LineItems] = []
}
