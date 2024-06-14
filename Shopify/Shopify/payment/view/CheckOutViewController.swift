//
//  CheckOutViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit


/* MARK: 
 1- fetch default address (done)
 2- fetch payment method -> table view ykhtar menooo (TODO) now is cash
 3- total price -> draft order CartVc price
 4- discount
 5- delivery
 6- total after calculations
 */
class CheckOutViewController: UIViewController, AddressSelectionDelegate {

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

    var total: Double = 9.0
    var addressVM : AddressViewModel!
    override func viewWillAppear(_ animated: Bool) {
        addressVM.fetchDeafultCustomerAddress(customerID: 7309504250029)
    }
    
    func didSelectAddress(_ address: Address) {
        addressdetails.text = address.address1
        print("inside Checout")
        print(address.address1)
        addressVM.defautltAdress = address
    }
    
    func createOrder(){
        let customer = Customer(id:7309504250029)
        let order = Orders(currency: "EGP", lineItems: CartList.cartItems, number: CartList.cartItems.count, customer: customer, totalPrice: cartViewModel.result?.total_price ?? "")
        checkOutVM.postOrder(order: order)
        print(order)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartViewModel = ShoppingCartViewModel()
        addressVM = AddressViewModel()
        checkOutVM = CheckOutViewModel()
        getDeafultAddress()
        cartViewModel.getCartItems()
        cartViewModel.editCart()
        setupBindings()
        getTotalPrice()
        orderPrice.text = String(total)
        
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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getTotalPrice() {
        cartViewModel.bindResultToViewController()
    }
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
    


    @IBAction func changeAddress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        if let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC") as? AddressVC {
            let navController = UINavigationController(rootViewController: addressVC)
           addressVC.coordinator = AddressCoordinator(navigationController: navController)
            addressVC.delegate = self 
            addressVC.shipmentAdress = true
           navController.modalPresentationStyle = .fullScreen
           self.present(navController, animated: true, completion: nil)
        }
        
        print("adddddressssss")
    }
    

}
