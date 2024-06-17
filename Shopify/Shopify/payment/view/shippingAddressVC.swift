//
//  shippingAddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 14/06/2024.
//
/*
 if count == 0 
 */
import UIKit
protocol ShippingAddressDelegate: AnyObject {
    func didSelectAddress(_ address: Address)
}

class shippingAddressVC: UITableViewController {
    private var viewModel = AddressViewModel()
    var editAdressVM = AddNewAddressViewModel()
    weak var delegate: ShippingAddressDelegate?
    let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)

//    var addressID: Int?
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        viewModel.fetchCustomerAddress(customerID: customerId)
        viewModel.bindToVC = { [weak self] in
                  DispatchQueue.main.async {
                      self?.tableView.reloadData()
                  }
              }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindToVC = { [weak self] in
                  DispatchQueue.main.async {
                      self?.tableView.reloadData()
                  }
              }
        tableView.separatorStyle = .none

              
              viewModel.fetchCustomerAddress(customerID: 7309504250029)
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addresses.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell else {
               return UITableViewCell()
           }
        cell.configure(with: viewModel.addresses[indexPath.row], indexPath: indexPath.row)
           return cell
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedAddress = viewModel.addresses[indexPath.row]
        selectedAddress.default = true
        editAdressVM.editAddress(customerID: 7309504250029, addressID: viewModel.addresses[indexPath.row].id ?? 0, address: selectedAddress) { success in
            print(selectedAddress)
            print("selectedAddress")
            DispatchQueue.main.async {
                if success {
                    print("Address updated successfully")
                    self.delegate?.didSelectAddress(selectedAddress)
                } else {
                    print("Error in updating address")
                }
            }
        }
               
               navigationController?.popViewController(animated: true)
    }


}
