//
//  CheckOutViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit


/* MARK: 
navigation to home mesh full screen
- discount
- delivery
 - default address
 if addressVM.addresses.count == 0 {
     
     coordinator?.showAddNewAddressWithEmptyFields()
 }
 else{
 */
class CheckOutViewController: UIViewController , AddressSelectionDelegate{
    func didSelectAddress(_ address: Address) {
        addressVM.defautltAdress = address
        addressdetails.text = address.address1
        print("inside Checout")
        print(address.address1)
    }
    

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
        addressVM.fetchDeafultCustomerAddress(customerID: customerId)
        bindResultToVC()
        updatePriceLabels()
        
    }
    
    
    func createOrder(){
        guard let resultCount = vm.result?.count, resultCount != 0 else {
            print("No results found, navigating to addressVC")
            navigateToAddressVC()
            return
        }
            let customer = Customer(id:customerId)
        guard let addresses = addressVM.defautltAdress else {
                 print("No default address found")
                 return
             }
            let shippingAddress = Shipping_address(from: addresses)
        cartViewModel.updateShippingAddress(newAddress: shippingAddress)
            let order = Orders(currency: UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "USD", lineItems: CartList.cartItems, number: CartList.cartItems.count, customer: customer, totalPrice: cartViewModel.result?.total_price ?? "", shippingAddress: shippingAddress)
            //TODO: shiiping addressssssssssss
            checkOutVM.postOrder(order: order)
            print("order cuurencyyyyyyyyyyyyyyy")
            print(UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY))
            
            print(order)
            
        
    }
    func navigateToAddressVC() {
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        if let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC") as? AddNewAddressVC {
            navigationController?.pushViewController(addressVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartViewModel = ShoppingCartViewModel()
        addressVM = AddressViewModel()
        checkOutVM = CheckOutViewModel()
        coordinator = AddressCoordinator(navigationController: self.navigationController!)
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
        self.navigationController?.popViewController(animated: true)
    }
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextViewController, animated: true)
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
    

}
