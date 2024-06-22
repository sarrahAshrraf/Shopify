//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 08/06/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var BrandName: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    
    var favoritesViewModel: FavoritesViewModel!
    
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"

    var product:Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoritesViewModel = FavoritesViewModel()
        showFavoriteBtn()
        configureContainerView()
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
    }
    
    private func configureContainerView() {
        containerView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        // Adding a custom view to the container with shadow
        containerView.backgroundColor = UIColor(named: "CardColor")
        containerView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
    }
    func setValues(product:Product, isFav: Bool) {
        self.product = product
        BrandName.text = Splitter().splitBrand(text: product.title ?? "", delimiter: "| ")
        productName.text = Splitter().splitName(text: product.title ?? "", delimiter: "| ")
        
        self.productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
                                      placeholder: UIImage(named: Constants.noImage))
        if isFav {
            self.favBtn.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
        } else {
            self.favBtn.setImage(UIImage(systemName: Constants.heart), for: .normal)
        }
    }
    
    
    func showFavoriteBtn(){
        if UserDefault().getCustomerId() == -1 {
            favBtn.isHidden = true
        }else {
            favBtn.isHidden = false
        }
    }
    
    
    @IBAction func favBtn(_ sender: Any) {
        if favBtn.currentImage == UIImage(systemName: Constants.heart) {
            let localProduct = LocalProduct(id: product.id, customer_id: defaults.integer(forKey: Constants.customerId), variant_id: product.variants?[0].id ?? 0, title: product.title ?? "", price: product.variants?[0].price ?? "", image: product.image?.src ?? "")
            favoritesViewModel.addProduct(product: localProduct)
            favoritesViewModel.getAllProducts()
            favBtn.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
            
        } else {
            let retrievedProduct = favoritesViewModel.getProduct(productId: self.product.id )
            favoritesViewModel.removeProduct(id: product.id)
            favoritesViewModel.getAllProducts()
            favBtn.setImage(UIImage(systemName: Constants.heart), for: .normal)
            
        }
        
    }
}
