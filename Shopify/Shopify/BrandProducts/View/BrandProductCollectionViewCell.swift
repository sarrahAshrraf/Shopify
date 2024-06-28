//
//  BrandProductCollectionViewCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit
import Kingfisher
import JGProgressHUD

class BrandProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var BrandName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    var product:Product!
    var favoritesViewModel: FavoritesViewModel!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "EGP"
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoritesViewModel = FavoritesViewModel()
        configureContainerView()
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) ?? "EGP"
            currencySymbol = symbol
        
        //showFavoriteBtn()
    
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
    
//    func setValues(product: Product, isFav: Bool , viewcontroller : UIViewController) {
//        
//        self.product = product
//        BrandName.text = Splitter().splitBrand(text: product.title ?? "", delimiter: "| ")
//        productLabel.text = Splitter().splitName(text: product.title ?? "", delimiter: "| ")
//        productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
//                                      placeholder: UIImage(named: Constants.noImage))
//        if let variant = product.variants?.first {
//            if let price = Double(variant.price) {
//                let convertedPrice = price * currencyRate
//                productPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
//            }
//        }
//        
//        if isFav {
//            favouriteButton.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
//        } else {
//            favouriteButton.setImage(UIImage(systemName: Constants.heart), for: .normal)
//        }
//        self.viewController = viewController as! BrandViewController
//    }
    func setValues(product: Product, isFav: Bool, viewController: UIViewController) {
            self.product = product
            BrandName.text = Splitter().splitBrand(text: product.title ?? "", delimiter: "| ")
            productLabel.text = Splitter().splitName(text: product.title ?? "", delimiter: "| ")
            productImage.kf.setImage(with: URL(string: product.image?.src ?? ""),
                                          placeholder: UIImage(named: Constants.noImage))
            if let variant = product.variants?.first, let price = Double(variant.price) {
                let convertedPrice = price * currencyRate
                productPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
            }
            
            favouriteButton.setImage(UIImage(systemName: isFav ? Constants.fillHeart : Constants.heart), for: .normal)
            self.viewController = viewController
        }
    
    func showFavoriteBtn(){
        if UserDefault().getCustomerId() == -1 {
            favouriteButton.isHidden = true
        }else {
            favouriteButton.isHidden = false
        }
    }
    
    func showProgress(message: String, in view: UIView, navigationController: UINavigationController?) {
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = message
        hud.square = true
        hud.style = .dark
        hud.show(in: view)
        hud.dismiss(afterDelay: 1, animated: true) {
            navigationController?.popViewController(animated: true)
        }
    }

    
    
//    @IBAction func checkFavouriteProduct(_ sender: Any) {
//        
//        if favouriteButton.currentImage == UIImage(systemName: Constants.heart) {
//            let localProduct = LocalProduct(id: product.id, customer_id: defaults.integer(forKey: Constants.customerId), variant_id: product.variants?[0].id ?? 0, title: product.title ?? "", price: product.variants?[0].price ?? "", image: product.image?.src ?? "")
//            print(localProduct)
//            favoritesViewModel.addProduct(product: localProduct)
//            favoritesViewModel.getAllProducts()
//            favouriteButton.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
//            
//        } else {
//            favoritesViewModel.removeProduct(id: product.id)
//            favoritesViewModel.getAllProducts()
//            favouriteButton.setImage(UIImage(systemName: Constants.heart), for: .normal)
//            
//            
//        }
//        
//        
//    }
    
    @IBAction func checkFavouriteProduct(_ sender: Any) {
        if UserDefault().getCustomerId() == -1 {
            Utilities.navigateToGuestScreen(viewController: viewController!)
        }else {
            if favouriteButton.currentImage == UIImage(systemName: Constants.heart) {
                let localProduct = LocalProduct(
                    id: product.id,
                    customer_id: defaults.integer(forKey: Constants.customerId),
                    variant_id: product.variants?[0].id ?? 0,
                    title: product.title ?? "",
                    price: product.variants?[0].price ?? "",
                    image: product.image?.src ?? ""
                )
                print(localProduct)
                favoritesViewModel.addProduct(product: localProduct)
                favoritesViewModel.getAllProducts()
                favouriteButton.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
                if let viewController = viewController as? BrandViewController {
                    showProgress(message: "Added to Favourite", in: viewController.view, navigationController: viewController.navigationController)
                }
            } else {
                favoritesViewModel.removeProduct(id: product.id)
                favoritesViewModel.getAllProducts()
                favouriteButton.setImage(UIImage(systemName: Constants.heart), for: .normal)
                if let viewController = viewController as? BrandViewController {
                    showProgress(message: "Deleted", in: viewController.view, navigationController: viewController.navigationController)
                }
            }
            
        }
    }
}
