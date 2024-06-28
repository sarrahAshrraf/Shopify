//
//  CheckOutViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit
import PassKit


class CheckOutViewController: UIViewController , AddressSelectionDelegate{


    @IBOutlet weak var changeAddress: UIButton!
    //    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var cashOnBtn: UIButton!
    @IBOutlet weak var discountValue: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var copounTF: UITextField!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var addressdetails: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var priceContainerView: UIStackView!
    @IBOutlet weak var addressContainerView: UIStackView!
    
    @IBOutlet weak var paymentContainerView: UIView!
    var cartViewModel : ShoppingCartViewModel!
    var checkOutVM : CheckOutViewModel!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "EGP"
    var usingCopoun = false
    var copounPercent = 0.0
    let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)
    var coordinator: AddressCoordinatorP?
    var discountCodeArray : [Discount_Codes] = []
    var total: Double = 9.0
    var addressVM : AddressViewModel!
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
//        addressVM.bindToVC = { [weak self] in
//            self?.addressdetails.text = self?.addressVM.defautltAdress?.address1 ?? "no address was added"
//
//        }
//        getDeafultAddress()
        bindResultToVC()
        updatePriceLabels()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartViewModel = ShoppingCartViewModel()
        addressVM = AddressViewModel()
        checkOutVM = CheckOutViewModel()
        coordinator = AddressCoordinator(viewController: self)
        getDeafultAddress()
        cartViewModel.getCartItems()
        cartViewModel.editCart()
        bindResultToVC()
        setupBindings()
        configureContainerView(containerView: priceContainerView)
        configureContainerView(containerView: addressContainerView)
        configurePaymentView()
//        getTotalPrice()
//        orderPrice.text = String(total)
        
    }
    
    func setupNavigationBar() {
        self.title = "Payment"
        if let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "home")
//        let nextViewController = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true)
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func setupBindings() {
        addressVM.bindDefaultAddress = { [weak self] in
            DispatchQueue.main.async {
                self?.addressdetails.text = self?.addressVM.defautltAdress?.address1 ?? "Add address"
                if self?.addressVM.defautltAdress?.address1 == nil{
                    self?.changeAddress.setTitle("Add", for: .normal)
                } else {
                    self?.changeAddress.setTitle("Change", for: .normal)
                    
                }
            }
        }
        
        cartViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.totalPrice.text = self?.cartViewModel.result?.subtotal_price
                print("TOTAL PRICE: \(String(describing: self?.cartViewModel.result?.total_price))")
                print("RESULT IS: \(String(describing:self?.cartViewModel.result))")
                self?.discountValue.text = self?.cartViewModel.result?.applied_discount?.amount ?? "0.0"
//                self?.orderItemsCount.text = String(self?.cartViewModel.result?.line_items?[CartList.cartItems.count].quantity ?? 0)
               
            }
        }
        checkOutVM.bindOrderToViewController = { [weak self] in
             DispatchQueue.main.async {
                 self?.showOrderSuccessAlert()
                 CartList.cartItems = []
                 self?.cartViewModel.editCart()
             }
         }
     }
    
    func showOrderSuccessAlert() {
        let alert = UIAlertController(title: "🥳 Success", message: "Order placed successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigateToHome()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func configureContainerView(containerView : UIStackView) {
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
    
    
    private func configurePaymentView() {
        paymentContainerView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        // Adding a custom view to the container with shadow
        paymentContainerView.backgroundColor = UIColor(named: "CardColor")
        paymentContainerView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        paymentContainerView.layer.shadowOffset = .zero
        paymentContainerView.layer.shadowOpacity = 0.2
        paymentContainerView.layer.shadowRadius = 5
        paymentContainerView.layer.cornerRadius = 20
    }

    
    func bindResultToVC() {
        cartViewModel.bindResultToViewController = { [weak self] in
            self?.setCurrencyValues()
            self?.updatePriceLabels()
        }
    }
    func setCurrencyValues() {
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
    }

    func getDeafultAddress(){
        
        addressVM.bindDefaultAddress = { [weak self] in
            DispatchQueue.main.async {
                self?.addressdetails.text = self?.addressVM.defautltAdress?.address1 ?? "Add address"
                if self?.addressVM.defautltAdress?.address1 == nil{
                    self?.changeAddress.setTitle("Add", for: .normal)
                } else {
                    self?.changeAddress.setTitle("Change", for: .normal)
                    
                }
            }
        }
        addressVM.fetchDeafultCustomerAddress(customerID: customerId)
    }


    func updatePriceLabels() {
        orderPrice.text = String(format: "\(currencySymbol) %.2f", total)
   
        if !usingCopoun{
            
            if let totalCartPrice = cartViewModel.result?.subtotal_price, let totalPrice = Double(totalCartPrice) {
                self.totalPrice.text = String(format: "\(currencySymbol) %.2f", totalPrice * currencyRate)
            } else {
                totalPrice.text = String(format: "\(currencySymbol) %.2f", 0.0)
            }

        }else{
            let discountedTotal = total * (copounPercent / 100)
            if let totalCartPrice = cartViewModel.result?.subtotal_price, let totalPrice = Double(totalCartPrice) {
                self.totalPrice.text = String(format: "\(currencySymbol) %.2f", (totalPrice * currencyRate) - abs(discountedTotal) )
                
            } else {
                totalPrice.text = String(format: "\(currencySymbol) %.2f", 0.0)
            }
            
            discountValue.text = String(format: "\(currencySymbol) %.2f", discountedTotal)
            
            
        }
    }
    
    func didSelectAddress(_ address: Address) {
        addressVM.defautltAdress = address
        addressdetails.text = address.address1
        print("inside Checout")
        print(address.address1)
    }
    
    @IBAction func changeAddress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        if let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC") as? AddressVC {
            addressVC.delegate = self
            addressVC.shipmentAdress = true
            let navController = UINavigationController(rootViewController: addressVC)
            navController.modalPresentationStyle = .formSheet
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
        
        print("adddddressssss")
    }
    func showAlertNoNetworkWithAction() {
        let alert = UIAlertController(title: "No Network", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Enable in settings", style: .default) { _ in
            if let url = URL(string: "App-Prefs:root=WIFI") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))

        present(alert, animated: true, completion: nil)
    }
    
    func isCardMethodSelected() -> Bool {
      if let cardLabel = self.view.viewWithTag(3) as? UILabel{
        if !cardLabel.isHidden{
          return true
        }else {
          return false
        }
      }
      return false
    }

    @IBAction func PurcasheVtn(_ sender: Any) {
        let paymentcontext = PaymentContext(pyamentStrategy: CashPaymentStrategy())
        if checkOutVM.checkInternetConnectivity() {
            if isCardMethodSelected() {
                paymentcontext.setPaymentStrategy(paymentStrategy: ApplePaymentStrategy())
            } else {
                createCashOrder()
            }
        } else {
            showAlertNoNetworkWithAction()
            return
        }
        
        var isPaymentSuccessful: (Bool, String) = (false, "")
    
        if usingCopoun {
            let discountedTotal = total * (copounPercent / 100)
            if let totalCartPrice = cartViewModel.result?.subtotal_price, let totalPrice = Double(totalCartPrice) {
                let updatedPrice = (totalPrice * currencyRate) - abs(discountedTotal)
                self.totalPrice.text = String(format: "\(currencySymbol) %.2f", updatedPrice)
                isPaymentSuccessful = paymentcontext.makePayment(moenyAmount: updatedPrice, viwController: self)
            }
        } else {
            isPaymentSuccessful = paymentcontext.makePayment(moenyAmount: self.total, viwController: self)
        }
        
        // Check payment result
        if isPaymentSuccessful.0 {
            if isPaymentSuccessful.1 == "Purchased successfully" {
                print("Payment succeeded")
            }
            print(isPaymentSuccessful.1)
        } else {
            print("Payment not succeeded")
            print(isPaymentSuccessful.1)
        }
    }
    
    func createOrder(){
        addressVM.fetchDeafultCustomerAddress(customerID: customerId)
        guard addressVM.defautltAdress != nil else {
             print("No results found, navigating to addressVC")
            coordinator?.showAddNewAddressWithEmptyFields()
             return
         }
            let customer = Customer(id:customerId)
        guard let addresses = addressVM.defautltAdress else {
                 print("No default address found")
                 return
             }
            let shippingAddress = Shipping_address(from: addresses)
        cartViewModel.updateShippingAddress(newAddress: shippingAddress)
        var updatedTotalPrice = cartViewModel.result?.subtotal_price ?? "0.00"
        var totalPrice = cartViewModel.result?.subtotal_price ?? "0.00"
           let totalPriceValue = Double(totalPrice)
        updatedTotalPrice = String((totalPriceValue ?? 0.00) * currencyRate)
        if usingCopoun{
            if let copounValue = defaults.value(forKey: Constants.copounValue) as? String {
                if let copounPercentValue = defaults.value(forKey: Constants.copounPercent) as? Double{
                    let positiveCopounPercent = abs(copounPercentValue)
                    let discounts = Discount_Codes(code: copounValue, amount: "\(positiveCopounPercent)", type: "percentage")
                    discountCodeArray.append(discounts)
                    print("in using copouns \(discountCodeArray)")
                }
            }
            
            let discountedTotal = total * (copounPercent / 100)
            var totalCartPrice = cartViewModel.result?.subtotal_price
            var totalPrice = Double(totalCartPrice ?? "0.0") ?? 0.0
            let sentPrice = (totalPrice * currencyRate) - abs(discountedTotal)
//                self.totalPrice.text = String(format: "\(currencySymbol) %.2f", (totalPrice * currencyRate) - abs(discountedTotal) )
                
            
            
            let order = Orders(currency: UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "EGP", lineItems: CartList.cartItems, number: CartList.cartItems.count, customer: customer, totalPrice: updatedTotalPrice, shippingAddress: shippingAddress, financialStatus: "paid", discount_codes: discountCodeArray)
                //TODO: shiiping addressssssssssss
                checkOutVM.postOrder(order: order)
            let cartItemsFormatted = formatCartItems(CartList.cartItems)

            var emailOrder = DraftOrderInvoice(to: UserDefaults.standard.string(forKey: Constants.USER_Email) ?? "", from: "abdosayed20162054@gmail.com", subject: "Your order is places successfully!", customMessage: "\(cartItemsFormatted)\n For amount of money: \(sentPrice) \(currencySymbol), as you get a discount  \(abs(discountedTotal) )\(currencySymbol) for using the coupon", bcc: ["abdosayed20162054@gmail.com"])
            print("==============================")
            print(CartList.cartItems)
            print("==============================")
            checkOutVM.postOrderToEmail(cartId: UserDefaults.standard.integer(forKey: Constants.cartId), emailOrder: emailOrder)
            
            
            
            
        
        } else {
            print("in remove all")
            discountCodeArray.removeAll()
            
            
            let order = Orders(currency: UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "EGP", lineItems: CartList.cartItems, number: CartList.cartItems.count, customer: customer, totalPrice: updatedTotalPrice, shippingAddress: shippingAddress, financialStatus: "paid", discount_codes: discountCodeArray)
                //TODO: shiiping addressssssssssss
                checkOutVM.postOrder(order: order)
            let cartItemsFormatted = formatCartItems(CartList.cartItems)

            var emailOrder = DraftOrderInvoice(to: UserDefaults.standard.string(forKey: Constants.USER_Email) ?? "", from: "abdosayed20162054@gmail.com", subject: "Your order is places successfully!", customMessage: "\(cartItemsFormatted)\n For amount of money: \(updatedTotalPrice) \(currencySymbol)", bcc: ["abdosayed20162054@gmail.com"])
       
            checkOutVM.postOrderToEmail(cartId: UserDefaults.standard.integer(forKey: Constants.cartId), emailOrder: emailOrder)
            
            
            
            
        }
            checkOutVM.updateVariantAfterPostOrder()

            
        
    }
    func createCashOrder() {
        addressVM.fetchDeafultCustomerAddress(customerID: customerId)
        guard addressVM.defautltAdress != nil else {
            print("No results found, navigating to addressVC")
            coordinator?.showAddNewAddressWithEmptyFields()
            return
        }
        
        let customer = Customer(id: customerId)
        guard let addresses = addressVM.defautltAdress else {
            print("No default address found")
            return
        }
        
        let shippingAddress = Shipping_address(from: addresses)
        cartViewModel.updateShippingAddress(newAddress: shippingAddress)
        
        var updatedTotalPrice = cartViewModel.result?.subtotal_price ?? "0.00"
        let totalPrice = cartViewModel.result?.subtotal_price ?? "0.00"
        var totalPriceValue = Double(totalPrice) ?? 0.00
        updatedTotalPrice = String(totalPriceValue * currencyRate)
        
        if usingCopoun{
            
            let discountedTotal = total * (copounPercent / 100)
            if let totalCartPrice = cartViewModel.result?.subtotal_price, let totalPrice = Double(totalCartPrice) {
                self.totalPrice.text = String(format: "\(currencySymbol) %.2f", (totalPrice * currencyRate) - abs(discountedTotal) )
                totalPriceValue = (totalPrice * currencyRate) - abs(discountedTotal)
                
            }
        }
        
        
        
        
        ////
        let cashPaymentStrategy = CashPaymentStrategy()
        let (isPaymentValid, paymentMessage) = cashPaymentStrategy.pay(moneyAmount: totalPriceValue * currencyRate, viwController: self)
        
        guard isPaymentValid else {
            print(paymentMessage)
            let alert = UIAlertController(title: "Payment", message: paymentMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        if usingCopoun{
            if let copounValue = defaults.value(forKey: Constants.copounValue) as? String {
                if let copounPercentValue = defaults.value(forKey: Constants.copounPercent) as? Double{
                    let positiveCopounPercent = abs(copounPercentValue)
                    let discounts = Discount_Codes(code: copounValue, amount: "\(positiveCopounPercent)", type: "percentage")
                    discountCodeArray.append(discounts)
                    print("in using copouns \(discountCodeArray)")
                }
            }
            let discountedTotal = total * (copounPercent / 100)
            var totalCartPrice = cartViewModel.result?.subtotal_price
            var totalPrice = Double(totalCartPrice ?? "0.0") ?? 0.0
            let sentPrice = (totalPrice * currencyRate) - abs(discountedTotal)
        
            let order = Orders(
                currency: UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "EGP",
                lineItems: CartList.cartItems,
                number: CartList.cartItems.count,
                customer: customer,
                totalPrice: updatedTotalPrice,
                shippingAddress: shippingAddress,
                financialStatus: "pending",
                discount_codes: discountCodeArray
            )
            
            checkOutVM.postOrder(order: order)
                    checkOutVM.updateVariantAfterPostOrder()

            let cartItemsFormatted = formatCartItems(CartList.cartItems)

            var emailOrder = DraftOrderInvoice(to: UserDefaults.standard.string(forKey: Constants.USER_Email) ?? "", from: "abdosayed20162054@gmail.com", subject: "Your order is placed successfully!", customMessage: "\(cartItemsFormatted)\n For amount of money: \(sentPrice) \(currencySymbol), as you get a discount \(discountedTotal) \(currencySymbol) for using the coupon", bcc: ["abdosayed20162054@gmail.com"])
       
            checkOutVM.postOrderToEmail(cartId: UserDefaults.standard.integer(forKey: Constants.cartId), emailOrder: emailOrder)
            
            
        } else {
            print("in remove all")
            discountCodeArray.removeAll()
            
            
            let order = Orders(
                currency: UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "EGP",
                lineItems: CartList.cartItems,
                number: CartList.cartItems.count,
                customer: customer,
                totalPrice: updatedTotalPrice,
                shippingAddress: shippingAddress,
                financialStatus: "pending",
                discount_codes: discountCodeArray
            )
            
            checkOutVM.postOrder(order: order)
                    checkOutVM.updateVariantAfterPostOrder()

            let cartItemsFormatted = formatCartItems(CartList.cartItems)

            var emailOrder = DraftOrderInvoice(to: UserDefaults.standard.string(forKey: Constants.USER_Email) ?? "", from: "abdosayed20162054@gmail.com", subject: "Your order is placed successfully!", customMessage: "\(cartItemsFormatted)\n For amount of money: \(updatedTotalPrice) \(currencySymbol)", bcc: ["abdosayed20162054@gmail.com"])
       
            
            checkOutVM.postOrderToEmail(cartId: UserDefaults.standard.integer(forKey: Constants.cartId), emailOrder: emailOrder)
            
        }



    }

    
    func formatCartItems(_ items: [LineItems]) -> String {
        var formattedString = ""
        for item in items {
            if let name = item.name, let quantity = item.quantity {
                formattedString += "Product name: \(name), Quantity: \(quantity)\n"
            }
        }
        return formattedString
    }
}



extension CheckOutViewController: PKPaymentAuthorizationViewControllerDelegate{
  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true)
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

    let paymentAuthorizationResult = PKPaymentAuthorizationResult(status: .success, errors: nil)
    completion(paymentAuthorizationResult)
    if paymentAuthorizationResult.status == .failure{
      print("failed")
    }

    if paymentAuthorizationResult.status == .success{
      print("success")
      controller.dismiss(animated: true)
        createOrder()
        showOrderSuccessAlert()
    }
  }

}
