//
//  CheckOutViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit
import PassKit


/* MARK:  navigation to home byzhar mn 8eer TAP BAR
- discount
 - apple pay
 */
class CheckOutViewController: UIViewController , AddressSelectionDelegate{
    func didSelectAddress(_ address: Address) {
        addressVM.defautltAdress = address
        addressdetails.text = address.address1
        print("inside Checout")
        print(address.address1)
    }
    

    @IBOutlet weak var taxesLabel: UILabel!
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
    var cartViewModel : ShoppingCartViewModel!
    var checkOutVM : CheckOutViewModel!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)
    var coordinator: AddressCoordinatorP?

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
        var updatedTotalPrice = cartViewModel.result?.total_price ?? "0.00"
        var totalPrice = cartViewModel.result?.total_price ?? "0.00"
           let totalPriceValue = Double(totalPrice)
        updatedTotalPrice = String((totalPriceValue ?? 0.00) * currencyRate)
            let order = Orders(currency: UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "USD", lineItems: CartList.cartItems, number: CartList.cartItems.count, customer: customer, totalPrice: updatedTotalPrice, shippingAddress: shippingAddress)
            //TODO: shiiping addressssssssssss
            checkOutVM.postOrder(order: order)
            print("order cuurencyyyyyyyyyyyyyyy")
            print(UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY))
//            checkOutVM.updateVariantAfterPostOrder()
            print(order)
            
        
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
//        getTotalPrice()
//        orderPrice.text = String(total)
        
    }
    
    private func setupBindings() {
        addressVM.bindDefaultAddress = { [weak self] in
            DispatchQueue.main.async {
                self?.addressdetails.text = self?.addressVM.defautltAdress?.address1
            }
        }
        
        cartViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.totalPrice.text = self?.cartViewModel.result?.total_price
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
        let alert = UIAlertController(title: "Success", message: "Order placed successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigateToHome()
        }))
        present(alert, animated: true, completion: nil)
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
    
//    func getTotalPrice() {
//        cartViewModel.bindResultToViewController()
//    }
    func getDeafultAddress(){
        
        addressVM.bindDefaultAddress = { [weak self] in
            DispatchQueue.main.async {
                self?.addressdetails.text = self?.addressVM.defautltAdress?.address1
            }
        }
        addressVM.fetchDeafultCustomerAddress(customerID: customerId)
    }
    
    @IBAction func PurcasheVtn(_ sender: Any) {
        createOrder()
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
    func updatePriceLabels() {
        orderPrice.text = String(format: "\(currencySymbol) %.2f", total)
        
        if let totalCartPrice = cartViewModel.result?.total_price, let totalPrice = Double(totalCartPrice) {
            self.totalPrice.text = String(format: "\(currencySymbol) %.2f", totalPrice * currencyRate)
        } else {
            totalPrice.text = String(format: "\(currencySymbol) %.2f", 0.0)
        }
        
        if let totalTax = cartViewModel.result?.total_tax, let totalTaxes = Double(totalTax) {
            self.taxesLabel.text = String(format: "\(currencySymbol) %.2f", totalTaxes * currencyRate)
        } else {
            taxesLabel.text = String(format: "\(currencySymbol) %.2f", 0.0)
        }
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
    

    @IBAction func cashBtn(_ sender: Any) {
    }
    @IBAction func applePAyBtn(_ sender: Any) {
        let paymentcontext = PaymentContext(pyamentStrategy: CashPaymentStrategy())
        
          paymentcontext.setPaymentStrategy(paymentStrategy: ApplePaymentStrategy())
        
        
        let isPaymentSuccessful = paymentcontext.makePayment(amount: self.total, vc: self)
        
        if isPaymentSuccessful.0 {
          if isPaymentSuccessful.1 == "Purchased successfully"{
              print("Pay succeeeeed")

          }
          print(isPaymentSuccessful.1)
        } else {
          print("not succeeeeed")
          print(isPaymentSuccessful.1)
        }
        
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
      // TODO: make the cart empty and send server req for payment
    }
  }

}
