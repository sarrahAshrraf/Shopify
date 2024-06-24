//
//  AddNewAddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit

class AddNewAddressVC: UIViewController, MapSelectionDelegate {
      var isEditingAddress = true
       var addressID: Int?
    weak var delegate: AddressProtocol?
    weak var checkOutDelegte : AddressSelectionDelegate!
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
                               self.checkOutDelegte?.didSelectAddress(address)
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
                               self.checkOutDelegte?.didSelectAddress(address)
                           } else {
                               print("Error in posting address")
                           }
                       }
                   }
               }
        
        dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
        
    @IBOutlet weak var phoneTF: RoundedTextfield!
    @IBOutlet weak var countryTF: RoundedTextfield!
    @IBOutlet weak var cityTF: RoundedTextfield!
    @IBOutlet weak var addressOneTF: RoundedTextfield!
    @IBOutlet weak var fullNameTF: RoundedTextfield!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
//    @IBOutlet weak var phoneTF: RoundedTextfield!!
//    @IBOutlet weak var countryTF: RoundedTextfield!!
//    @IBOutlet weak var cityTF: RoundedTextfield!!
//
//    @IBOutlet weak var addressOneTF: RoundedTextfield!!
//    @IBOutlet weak var fullNameTF: RoundedTextfield!!
    var viewModell: AddNewAddressViewModel!
    var addVM : AddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addVM = AddressViewModel()
        getAddressArrayCount()
        populateTextFields()
        setupUI()

        print(isEditingAddress)
        print(customerId)
    }
    
    private func getAddressArrayCount() {
           addVM.bindToVC = { [weak self] in
               DispatchQueue.main.async {
                   if self?.addVM.addresses.count == 0 {
                       self?.isDefaultAddress = true
                       self?.switchDeafultBtn.isOn = true
                   } 
               }
           }
           addVM.fetchCustomerAddress(customerID: customerId)
       }
    
    
    private func populateTextFields() {
      
        guard let viewModel = viewModell else {
                  print("ViewModel is nil")
                  return
              }
//        fullNameTF.text = viewModel.fullName
//        addressOneTF.text = viewModel.addressOne
////        addressTwoTF.text = viewModel.addressTwo
//        cityTF.text = viewModel.city
//        phoneTF.text = viewModel.phone
//        countryTF.text = viewModel.country
        
        cityTF.setText(viewModel.city ?? "")
        fullNameTF.setText(viewModel.fullName ?? "")
        addressOneTF.setText(viewModel.addressOne ?? "")
        phoneTF.setText(viewModel.phone ?? "")
        countryTF.setText(viewModel.country ?? "")

    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        getAddressArrayCount()
        switchDeafultBtn.isOn = isDefaultAddress

    }

    private func setupNavigationBar() {
           self.title = isEditingAddress ? "Edit Address" : "Add Address"
//           let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
//           self.navigationItem.leftBarButtonItem = backButton
        
        if let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            
            navigationItem.leftBarButtonItem = backButton
        }
//           let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
//           self.navigationItem.rightBarButtonItem = saveButton
       }
    
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
//         self.navigationController?.popViewController(animated: true)
     }
     
    @IBAction func openMapBtn(_ sender: Any) {
        let mapVC = MapViewController()
                mapVC.delegate = self
        let navController = UINavigationController(rootViewController: mapVC)
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true, completion: nil)
//        present(mapVC, animated: true)
//                navigationController?.pushViewController(mapVC, animated: true)
        
        
    }
    func didSelectLocation(address: String, city: String, country: String, latitude: Double, longitude: Double) {
        
        addressOneTF.setText(address)
        cityTF.setText(city)
        countryTF.setText(country)
//           addressOneTF.text = address
//           cityTF.text = city
//           countryTF.text = country
        print("Selected Address: \(address)")
        print("Coordinates: (\(latitude), \(longitude))")
    }
    
    
    private func setupUI() {
        setupMapButton()
        setupAddButton()
    }
    
    private func setupMapButton() {
        mapBtn.backgroundColor = .white
        mapBtn.tintColor = .black
        mapBtn.layer.borderWidth = 2
        mapBtn.layer.borderColor = UIColor.black.cgColor
        mapBtn.layer.cornerRadius = mapBtn.frame.height / 2
        mapBtn.clipsToBounds = true
        mapBtn.setTitle("Select From Map", for: .normal)
    }
    
    private func setupAddButton() {
        addBtn.tintColor = .white
        addBtn.backgroundColor = .black
        addBtn.layer.cornerRadius = addBtn.frame.height / 2
        addBtn.clipsToBounds = true
        addBtn.setTitle("Save", for: .normal)
        addBtn.addAction(.init(handler: { [weak self] _ in self?.saveButtonTapped() }), for: .touchUpInside)
    }
    
}

//extension  AddNewAddressVC:  UITextFieldDelegate{
//  
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.cityTF.resignFirstResponder()
//        self.countryTF.resignFirstResponder()
//        self.fullNameTF.resignFirstResponder()
//        self.phoneTF.resignFirstResponder()
////        self.provinceTF.resignFirstResponder()
//        self.addressOneTF.resignFirstResponder()
////        self.addressTwoTF.resignFirstResponder()
//
//        return true
//    }


//}
