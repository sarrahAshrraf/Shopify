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
}
/*
 fix total price bug
 */
class CartCell: UITableViewCell {
    var viewController: CartViewController?
    weak var delegate: CartCellDelegate?

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
        plusBtn.isEnabled = true
        viewController!.cartPrice = Double(viewController!.cartPrice) - Double(productCount) * Double(itemInCart.price!)!
        productCount -= 1
        viewController!.cartPrice = Double(viewController!.cartPrice) + Double(productCount) * Double(itemInCart.price!)!
        quantityLabel.text = "\(productCount)"
        updateItemsQuantityInShoppingCartList()
        
        if productCount == 1 {
            minusBtn.isEnabled = false
        }
        
    }
    @IBAction func plusBtn(_ sender: Any) {
        print("plussssssssss")
        minusBtn.isEnabled = true
        if totalAvailableVariantInStock > 3 && productCount < totalAvailableVariantInStock/3 || totalAvailableVariantInStock <= 3 && productCount < totalAvailableVariantInStock {
            viewController!.cartPrice = Double(viewController!.cartPrice) - Double(productCount) * Double(itemInCart.price!)!
            productCount += 1
            viewController!.cartPrice = Double(viewController!.cartPrice) + Double(productCount) * Double(itemInCart.price!)!
            quantityLabel.text = "\(productCount)"
            updateItemsQuantityInShoppingCartList()
            
            if totalAvailableVariantInStock > 3 && productCount < totalAvailableVariantInStock/3 || totalAvailableVariantInStock <= 3 && productCount < totalAvailableVariantInStock {
                
            }else{
                print("Can not Add more")
                plusBtn.isEnabled = false
            }
        }

        
    }
    @IBAction func deleteBtn(_ sender: Any) {
        delegate?.deleteItem(self)
        print("delete btn")

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 4.1)
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with item: [LineItems], index: Int) {
        titleLabel.text = item[index].name
        priceLabel.text = item[index].price
        print(item[index].name)

    }
    
    
    func setCartItemValues(lineItem: LineItems, viewController: CartViewController){
        let imageUrl = (lineItem.properties?[0].value?.split(separator: "$")[0])!
        self.itemImg.kf.setImage(with: URL(string: String(imageUrl)),placeholder: UIImage(named: "noImage"))
        self.titleLabel.text = lineItem.name
        self.brandLabel.text = "\(lineItem.vendor ?? "") / \((lineItem.variantTitle) ?? "")"
        self.priceLabel.text = lineItem.price
        self.quantityLabel.text = "\((lineItem.quantity) ?? 0)"
        productCount = lineItem.quantity ?? 0
        if productCount == 1 {
            minusBtn.isEnabled = false
        }
        totalAvailableVariantInStock = Int(lineItem.properties?[0].name ?? "1") ?? 1
        if totalAvailableVariantInStock > 3 && productCount < totalAvailableVariantInStock/3 || totalAvailableVariantInStock <= 3 && productCount < totalAvailableVariantInStock {
            
        }else{
            plusBtn.isEnabled = false
        }
        
        self.viewController = viewController
        self.itemInCart = lineItem
    }
    
    func updateItemsQuantityInShoppingCartList (){
        for (index , item) in CartList.cartItems.enumerated() {
            if item.variantId == itemInCart.variantId {
                CartList.cartItems[index].quantity = productCount
            }
//            CartList.cartItems[index].quantity = productCount
        }
        viewModel.editCart()
        
    }
}
class CartList{
    static var cartItems: [LineItems] = []
}
