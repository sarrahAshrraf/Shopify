//
//  AddNewAddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit

class AddNewAddressVC: UIViewController {
      var isEditingAddress = true
       var addressID: Int?
    weak var delegate: AddressProtocol?
    var isDefaultAddress = false
    let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)
    @IBOutlet weak var switchDeafultBtn: UISwitch!
    @objc private func saveButtonTapped() {

            
        guard let fullName = fullNameTF.text,
               !fullName.isEmpty,
               let address1 = addressOneTF.text,
               !address1.isEmpty,
//               let address2 = addressTwoTF.text,
//               !address2.isEmpty,
               let city = cityTF.text,
               !city.isEmpty,
               let country = countryTF.text,
               !country.isEmpty,
               let phone = phoneTF.text,
              !phone.isEmpty else {
            print("empty fields")
            let alert = UIAlertController(title: "Warning", message: "You must fill out all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let nameParts = fullName.split(separator: " ")
        let firstName = nameParts.first.map(String.init) ?? ""
        let lastName = nameParts.dropFirst().joined(separator: " ")

        let address = Address(
                    id: addressID,
                    customer_id: customerId,
                    name: "\(firstName)\(" ")\(lastName)",
                    first_name: firstName,
                    last_name: lastName,
                    phone: phone,
                    company: "ITI",
                    address1: address1,
                    address2: "",
                    city: city,
                    province: "",
                    country: country,
                    zip: "zip",
                    province_code: "",
                    country_code: "",
                    country_name: "",
                    default: switchDeafultBtn.isOn
                )
//        MARK: customerid is given from keychain
//        viewModell.postCustomerAddress(customerID: 7309504250029, address: address) { success in
//            DispatchQueue.main.async {
//                if success {
//                    print("posted")
//                } else {
//                    print("error in posting")
//                }
//            }
//        } 
        
        
        
        if isEditingAddress, let addressID = addressID {
                   viewModell.editAddress(customerID: customerId, addressID: addressID, address: address) { success in
                      print("addressssdghjk")
                       print(address)
                       DispatchQueue.main.async {
                           if success {
                               print(address)
                               print("Address updated successfully")
                               self.delegate?.didUpdateAddress()

                           } else {
                               print("Error in updating address")
                           }
                       }
                   }
               } else {
                   viewModell.postCustomerAddress(customerID: customerId, address: address) { success in
                       DispatchQueue.main.async {
                           if success {
                               print("Address posted successfully")
                               self.delegate?.didUpdateAddress()

                           } else {
                               print("Error in posting address")
                           }
                       }
                   }
               }
        
        
        self.navigationController?.popViewController(animated: true)
    }
        
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!

    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    var viewModell: AddNewAddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTextFields()
        print(isEditingAddress)
        print(customerId)

    }
    

    
    private func populateTextFields() {
      
        guard let viewModel = viewModell else {
                  print("ViewModel is nil")
                  return
              }
        fullNameTF.text = viewModel.fullName
        addressOneTF.text = viewModel.addressOne
//        addressTwoTF.text = viewModel.addressTwo
        cityTF.text = viewModel.city
        phoneTF.text = viewModel.phone
        countryTF.text = viewModel.country
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        switchDeafultBtn.isOn = isDefaultAddress

    }

    private func setupNavigationBar() {
           self.title = isEditingAddress ? "Edit Address" : "Add Address"
           let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
           self.navigationItem.leftBarButtonItem = backButton
           let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
           self.navigationItem.rightBarButtonItem = saveButton
       }
    
    
    @objc private func backButtonTapped() {
         self.navigationController?.popViewController(animated: true)
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
//        self.addressTwoTF.resignFirstResponder()

        return true
    }


}
