//
//  AddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit


class AddressVC: UIViewController , UITableViewDataSource, UITableViewDelegate , AddressProtocol{
    var coordinator: AddressCoordinatorP?
    weak var delegate: AddressSelectionDelegate?

    var shipmentAdress : Bool = false
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func addNewAddressBtn(_ sender: Any) {
        coordinator?.showAddNewAddressWithEmptyFields()
        

    }
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var addressTableView: UITableView!
    private var viewModel = AddressViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.fetchCustomerAddress(customerID: 7309504250029)
        viewModel.bindToVC = { [weak self] in
                  DispatchQueue.main.async {
                      self?.addressTableView.reloadData()
                  }
              }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = AddressCoordinator(navigationController: self.navigationController!)
        addressTableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")

        viewModel.bindToVC = { [weak self] in
                  DispatchQueue.main.async {
                      self?.addressTableView.reloadData()
                  }
              }
        addressTableView.separatorStyle = .none

              
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if(shipmentAdress == false){
              coordinator?.showAddNewAddress(with: viewModel.addresses[indexPath.row])
            print("inside select row")
          }else {
                     delegate?.didSelectAddress(viewModel.addresses[indexPath.row])
              print(viewModel.addresses[indexPath.row])
              let storyboard = UIStoryboard(name: "Payment_SB", bundle: nil)
              if let checkOutVC = storyboard.instantiateViewController(withIdentifier: "checkOutVC") as? CheckOutViewController {
                  let navController = UINavigationController(rootViewController: checkOutVC)
//                  checkOutVC.shippingAddress = viewModel.addresses[indexPath.row].address1 ?? ""
                 navController.modalPresentationStyle = .fullScreen
                 self.present(navController, animated: true, completion: nil)
              }
          }
      }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                viewModel.deleteAddress(customerID: 7309504250029, addressID: viewModel.addresses[indexPath.row].id ?? 0, address: viewModel.addresses[indexPath.row]) { success in
                    DispatchQueue.main.async {
                        if success {
                            print("Address deleted successfully")
                        
                            self.viewModel.fetchCustomerAddress(customerID: 7309504250029)
                            self.addressTableView.reloadData()
                        } else {
                            print("Error in deleting address")
                            let alert = UIAlertController(title: "Error", message: "You can not delete deafult address.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func didUpdateAddress() {
          viewModel.fetchCustomerAddress(customerID: 7309504250029)
      }
    }

  


