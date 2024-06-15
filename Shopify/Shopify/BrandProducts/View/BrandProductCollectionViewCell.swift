//
//  BrandProductCollectionViewCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit
import Kingfisher

class BrandProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    var product:Product!
    var favoritesViewModel: FavoritesViewModel!
    let defaults = UserDefaults.standard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoritesViewModel = FavoritesViewModel()
    }
    
    func setValues(product:Product ,isFav: Bool) {
        print("Success2")
        self.product = product
        self.productLabel.text = product.title ?? ""
        self.productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
                                      placeholder: UIImage(named: Constants.noImage))
        if product.variants?.count ?? 0 > 0{
            
            self.productPrice.text = product.variants![0].price
        }
        
        if isFav {
            self.favouriteButton.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
        } else {
            self.favouriteButton.setImage(UIImage(systemName: Constants.heart), for: .normal)
        }
    }
    
    
    @IBAction func checkFavouriteProduct(_ sender: Any) {
        
        if favouriteButton.currentImage == UIImage(systemName: Constants.heart) {
            let localProduct = LocalProduct(id: product.id, customer_id: defaults.integer(forKey: Constants.customerId), variant_id: product.variants?[0].id ?? 0, title: product.title ?? "", price: product.variants?[0].price ?? "", image: product.image?.src ?? "")
            favoritesViewModel.addProduct(product: localProduct)
            favoritesViewModel.getAllProducts()
            favouriteButton.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
            
        } else {
            let retrievedProduct = favoritesViewModel.getProduct(productId: self.product.id )
            favoritesViewModel.removeProduct(id: product.id)
            favoritesViewModel.getAllProducts()
            favouriteButton.setImage(UIImage(systemName: Constants.heart), for: .normal)
            
        }
        
        
    }
}
