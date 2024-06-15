//
//  ProductDetailsViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit
import Kingfisher


class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var counterTextField: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productVendorAndType: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stockCount: UILabel!
    
    var viewModel: ProductDetailsViewModel!
    var customerID = 7309504250029
    var generalViewModel: ShoppingCartViewModel!
    var orderCount = 1
    var productInCart = false
//MARK: To be changed color and sizeeee values !!!!
    var selectedSize: String = "10"
        var selectedColor =  "white"
                
    override func viewDidLoad() {
        super.viewDidLoad()
        generalViewModel = ShoppingCartViewModel()
        //viewModel = ProductDetailsViewModel()
        fetchData()
        showData()
        
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        print("success")
        viewModel.getItems()
        print("viewModel.result?.variants")

        print(viewModel.result?.variants)
        print(viewModel.result?.variants?.first?.option1)
        print(viewModel.result?.variants?.first?.option2)


    }
    
    func showData(){
      viewModel.bindResultToViewController = { [weak self] in

        DispatchQueue.main.async {
            self?.productName.text = self?.viewModel.result?.title
            self?.descriptionLabel.text = self?.viewModel.result?.bodyHtml
            self?.price.text = self?.viewModel.result?.variants?.first?.price
            self?.productVendorAndType.text = (self?.viewModel.result?.vendor ?? "") + "," + (self?.viewModel.result?.productType ?? "")

            self?.productImage.kf.setImage(with: URL(string: self?.viewModel.result?.image?.src ?? " " ),
                                          placeholder: UIImage(named: Constants.noImage))
            self?.stockCount.text = "\(self?.viewModel.result?.variants?.first?.inventoryQuantity ?? 0)"

        }
      }
    }
    func checkPriceAndAvailability(){
        if selectedSize == nil || selectedColor == nil {}
        else{
            for variant in viewModel.result?.variants ?? []{
                let variantName = "\(selectedSize) / \(selectedColor)"
                if variant.title! == variantName{
                    price.text = String(variant.price)
                    if variant.inventoryQuantity == nil || variant.inventoryQuantity == 0 {
                        stockCount.text = "Not Available"
                    }else{
                        stockCount.text = "\(variant.inventoryQuantity!) In Stock"
                    }
                }
            }
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func addToCart(_ sender: Any) {
       //MARK: TODO: get user id from userDeafulttttt
        
        if customerID != -1{
            orderCount = Int(counterTextField.text!)!
            let variantName = "\(selectedSize) / \(selectedColor)"
            var variantId = 0
            for variant in viewModel.result?.variants ?? [] {
                if variant.title ?? "" == variantName {
                    variantId = variant.id!
                }
            }
            let variantCartStatus = checkVariantIsInCart(variantId: variantId)
            if variantCartStatus.0 {
                if canUpdateCartAmount(variantIndex: variantCartStatus.1) {
                    updateCartAmountAndResetCounter(variantIndex: variantCartStatus.1)
                }else {
                    presentAmountErrorAlert(variantIndex: variantCartStatus.1)
                }
            }else{
                addVariantToOrders(variantName: variantName)
            }
        }else {
            let alert = UIAlertController(title: "Warning", message: "You must login first!", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func minusBtn(_ sender: Any) {
        let count = Int(counterTextField.text ?? "1")! - 1
        counterTextField.text = String(count)
        if count != 1 {
            minusBtn.isEnabled = true
        }
    }
    

    @IBAction func addBtn(_ sender: Any) {
        let count = Int(counterTextField.text ?? "1")
        counterTextField.text = String((count ?? 1) + 1)
        minusBtn.isEnabled = true
    }
    
    func addVariantToOrders(variantName: String){
        for variant in viewModel.result?.variants ?? [] {
            if variant.title == variantName {
                if variant.inventoryQuantity! > 3 && orderCount <= variant.inventoryQuantity!/3 || variant.inventoryQuantity! <= 3 && orderCount <= variant.inventoryQuantity! {
                    let lineItem = LineItems(name: viewModel.result?.title,price: variant.price, productId: viewModel.result?.id , quantity: orderCount, variantId: variant.id, variantTitle: variantName ,vendor: viewModel.result?.vendor, properties: [Properties(name: String(variant.inventoryQuantity!), value: "\((viewModel.result?.image?.src)!)$\(variant.inventoryItemId!)")])
                    CartList.cartItems.append(lineItem)
                    generalViewModel.result?.line_items?.append(lineItem)
                    generalViewModel.editCart()
                    orderCount = 1
                }else{
                    print("you can not")
                    let alert = UIAlertController(title: "Warning", message: "You can not order more than \(variant.inventoryQuantity!/3).", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(alert, animated: true, completion: nil)

                }
            }
        }
    }
    
    func checkVariantIsInCart(variantId: Int) -> (Bool, Int){
        for (index, item) in CartList.cartItems.enumerated(){
            if item.variantId == variantId {
                return (true , index)
            }
        }
        return (false , -1)
    }
    
    
    func canUpdateCartAmount(variantIndex: Int) -> Bool{
        let currentAmountInCart = CartList.cartItems[variantIndex].quantity!
        let totalAmountInStock = Int(CartList.cartItems[variantIndex].properties?[0].name ?? "1") ?? 1
        if (totalAmountInStock > 3 && currentAmountInCart + orderCount <= totalAmountInStock/3) || (totalAmountInStock <= 3 && currentAmountInCart + orderCount <= totalAmountInStock){
            return true
        }else {
            return false
        }
    }
    
    func updateCartAmountAndResetCounter(variantIndex: Int){
        CartList.cartItems[variantIndex].quantity! += orderCount
        generalViewModel.result?.line_items?[variantIndex].quantity! += orderCount
        orderCount = 1
        generalViewModel.editCart()
    }
    
    func presentAmountErrorAlert(variantIndex: Int){
        let currentAmountInCart = CartList.cartItems[variantIndex].quantity!
//        let currentAmountIncart = generalViewModel.result?.line_items?[variantIndex].quantity ?? 0
        let totalAmountInStock = Int(CartList.cartItems[variantIndex].properties?[0].name ?? "1") ?? 1
//        let totalAmountInstock = Int(generalViewModel.result?.line_items?[variantIndex].properties?[0].name ?? "1") ?? 1
        var cartCount = 0
        if totalAmountInStock <= 3{
            cartCount = totalAmountInStock
        }else{
            cartCount = totalAmountInStock / 3
        }
        print("you can not order more")
        let alert = UIAlertController(title: "Warning", message: "You can not order more than \(cartCount).", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)

    }
    
}
