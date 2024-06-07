//
//  AddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit

class AddressVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func addNewAddressBtn(_ sender: Any) {
    }
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var addressTableView: UITableView!
    private var viewModel = AddressViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")

        viewModel.bindToVC = { [weak self] in
                  DispatchQueue.main.async {
                      self?.addressTableView.reloadData()
                  }
              }
              
              viewModel.fetchCustomerAddress(customerID: 7309504250029)
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell else {
               return UITableViewCell()
           }
        cell.configure(with: viewModel.addresses[indexPath.row], indexPath: indexPath.row)
           return cell
       }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        guard let selectedAddress = viewModel.address(at: indexPath.row) else {
//            return
//        }
//
//        let addAddressViewModel = AddAddressViewModel(address: selectedAddress)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let addAddressVC = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else {
//            return
//        }
//
//        addAddressVC.viewModel = addAddressViewModel
//        navigationController?.pushViewController(addAddressVC, animated: true)
//    }

}

  


