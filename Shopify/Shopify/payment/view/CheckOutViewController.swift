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
class CheckOutViewController: UIViewController {

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

    var addressVM : AddressViewModel!
    override func viewWillAppear(_ animated: Bool) {

        addressVM.fetchDeafultCustomerAddress(customerID: 7309504250029)
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
                self?.discountValue.text = self?.cartViewModel.result?.applied_discount?.amount

            }
        }
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
    
    func checkOutProcess(){
        //post the order 
        
        
        
    }
    



    @IBAction func changeAddress(_ sender: Any) {
        
        print("adddddressssss")
    }
    
//    func didSelectAddress(_ address: Address) {
//        print("in did select addresss")
//           addressdetails.text = address.address1
//           let newShippingAddress = Shipping_address(
//               first_name: "sarah",
//               address1: "Miaaaami",
//               phone: "012873654",
//               city: "alexxxxxx",
//               zip: address.zip,
//               province: address.province,
//               country: "Egypt",
//               last_name: "ashraf",
//               address2: address.address2,
//               company: address.company,
//               latitude: "",
//               longitude:"",
//               name: address.name,
//               country_code: address.country_code,
//               province_code: address.province_code
//           )
//           cartViewModel.updateShippingAddress(newAddress: newShippingAddress)
//       }
}
