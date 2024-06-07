//
//  AddNewAddressVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 07/06/2024.
//

import UIKit

class AddNewAddressVC: UIViewController {
    
    @IBAction func saveBtn(_ sender: Any) {
            
    }
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var provinceTF: UITextField!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    var  viewModel: AddressViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel()
        
        viewModel.bindToVC = { [weak self] in
            DispatchQueue.main.async {
                func configure(with address: Address) {
                    self?.viewModel.addresses[0] = address
                    self?.populateAddressFields(with: self!.viewModel.addresses[0])
                }
                
            }
        }
        
    }
    
    
    
    func configure(with address: Address) {
       viewModel.addresses[0] = address}

    private func populateAddressFields(with address: Address) {
        countryTF.text = address.country
        cityTF.text = address.city
        provinceTF.text = address.province
        addressTwoTF.text = address.address2
        addressOneTF.text = address.address1
        fullNameTF.text = address.firstName
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

