//
//  AddNewAddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit

class AddNewAddressVC: UIViewController {
    
    @IBAction func saveBtn(_ sender: Any) {
            
//        guard let fullName = fullNameTF.text,
//              let address1 = addressOneTF.text,
//              let address2 = addressTwoTF.text,
//              let city = cityTF.text,
//              let province = provinceTF.text,
//              let country = countryTF.text,
//              let phone = phoneTF.text else {
//            print("empty fields")
//            return
//        }
//        
//        let nameParts = fullName.split(separator: " ")
//        let firstName = nameParts.first.map(String.init) ?? ""
//        let lastName = nameParts.dropFirst().joined(separator: " ")
//        
        let address = Address(
                    id: nil,
                    customer_id: 7309504250029,
                    name: "fullName",
                    first_name: "Sarah",
                    last_name: "ASHRAF",
                    phone: "0346545267189",
                    company: "ITI",
                    address1: "Add",
                    address2: "Tesst two",
                    city: "ASWAN",
                    province: "",
                    country: "EGYPT",
                    zip: "zip",
                    province_code: "",
                    country_code: "",
                    country_name: "",
                    default: false
                )
        
        viewModel.postCustomerAddress(customerID: 7309504250029, address: address) { success in
            DispatchQueue.main.async {
                if success {
                    print("posted")
                } else {
                    print("error in posting")
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
        
    
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var provinceTF: UITextField!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    var viewModel: AddNewAddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddNewAddressViewModel()
//        populateTextFields()
        
    }
//    private func populateTextFields() {
//        fullNameTF.text = viewModel.fullName
//        addressOneTF.text = viewModel.addressOne
//        addressTwoTF.text = viewModel.addressTwo
//        cityTF.text = viewModel.city
//        provinceTF.text = viewModel.province
//        countryTF.text = viewModel.country
//    }
    
    
    

}

