//
//  CheckOutViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit
/* MARK: 
 1- fetch default address
 2- fetch payment method -> table view ykhtab menooo
 3- total price -> draft order CartVc price
 4- discount
 5- delivery
 6- total after calculations
 */
class CheckOutViewController: UIViewController {

    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var copounTF: UITextField!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var addressdetails: UILabel!
    @IBOutlet weak var addressType: UILabel!
    var cartViewModel : ShoppingCartViewModel!
    var addressVM : AddressViewModel!
    override func viewWillAppear(_ animated: Bool) {
        addressVM.fetchDeafultCustomerAddress(customerID: 7309504250029)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartViewModel = ShoppingCartViewModel()
        addressVM = AddressViewModel()
        getDeafultAddress()
        cartViewModel.showCartItems()
        getTotalPrice()
        
    }
    func getDeafultAddress(){
        
        addressVM.bindDefaultAddress = { [weak self] in
            DispatchQueue.main.async {
                self?.addressdetails.text = self?.addressVM.defautltAdress?.address1
            }
        }
    }
    func getTotalPrice(){
        cartViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.totalPrice.text = self?.cartViewModel.result?.lineItems?.first?.price
                print("TOTAAAL")
                print(self?.cartViewModel.result?.total_price)
            }
            
            
        }
        
        
    }
    



    @IBAction func changeAddress(_ sender: Any) {
    }
}
