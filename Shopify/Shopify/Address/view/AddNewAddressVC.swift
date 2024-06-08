//
//  AddNewAddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit

class AddNewAddressVC: UIViewController {
    
    @IBAction func saveBtn(_ sender: Any) {
            
        guard let fullName = fullNameTF.text,
              let address1 = addressOneTF.text,
              let address2 = addressTwoTF.text,
              let city = cityTF.text,
//              let province = provinceTF.text,
              let country = countryTF.text,
              let phone = phoneTF.text else {
            print("empty fields")
//            MARK: ALerttttttttttt
            
            return
        }
        
        let nameParts = fullName.split(separator: " ")
        let firstName = nameParts.first.map(String.init) ?? ""
        let lastName = nameParts.dropFirst().joined(separator: " ")

        let address = Address(
                    id: nil,
                    customer_id: 7309504250029,
                    name: "\(firstName)\(" ")\(lastName)",
                    first_name: firstName,
                    last_name: lastName,
                    phone: phone,
                    company: "ITI",
                    address1: address1,
                    address2: address2,
                    city: city,
                    province: "",
                    country: country,
                    zip: "zip",
                    province_code: "",
                    country_code: "",
                    country_name: "",
                    default: false
                )
//        MARK: customerid is given from keychain
        viewModell.postCustomerAddress(customerID: 7309504250029, address: address) { success in
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
        
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
//    @IBOutlet weak var provinceTF: UITextField!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    var viewModell: AddNewAddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel = AddNewAddressViewModel()
        populateTextFields()
//        self.cityTF.delegate = self
    }
    

    
    private func populateTextFields() {
      
        guard let viewModel = viewModell else {
                  print("ViewModel is nil")
                  return
              }
        fullNameTF.text = viewModel.fullName
        addressOneTF.text = viewModel.addressOne
        addressTwoTF.text = viewModel.addressTwo
        cityTF.text = viewModel.city
        phoneTF.text = viewModel.phone
        countryTF.text = viewModel.country
    }
    

}

extension  AddNewAddressVC:  UITextFieldDelegate{
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.cityTF.resignFirstResponder()
        self.countryTF.resignFirstResponder()
        self.fullNameTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
//        self.provinceTF.resignFirstResponder()
        self.addressOneTF.resignFirstResponder()
        self.addressTwoTF.resignFirstResponder()

        return true
    }


}
