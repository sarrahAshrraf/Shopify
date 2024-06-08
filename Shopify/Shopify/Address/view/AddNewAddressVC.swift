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
    var viewModel: AddNewAddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTextFields()
        
    }
    private func populateTextFields() {
        fullNameTF.text = viewModel.fullName
        addressOneTF.text = viewModel.addressOne
        addressTwoTF.text = viewModel.addressTwo
        cityTF.text = viewModel.city
        provinceTF.text = viewModel.province
        countryTF.text = viewModel.country
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

