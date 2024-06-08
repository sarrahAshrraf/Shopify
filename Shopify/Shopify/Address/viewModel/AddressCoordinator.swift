//
//  AddressCoordinator.swift
//  Shopify
//
//  Created by sarrah ashraf on 08/06/2024.
//

import Foundation
import UIKit
protocol AddressCoordinatorP {
    func showAddNewAddress(with address: Address?)
    func showAddNewAddressWithEmptyFields()

}

class AddressCoordinator: AddressCoordinatorP {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showAddNewAddress(with address: Address?) {
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        guard let addNewAddressVC = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddNewAddressVC else { return }
        let viewModel = AddNewAddressViewModel(address: address)
        addNewAddressVC.viewModell = viewModel
        navigationController.pushViewController(addNewAddressVC, animated: true)
    }
    
    func showAddNewAddressWithEmptyFields() {
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        guard let addNewAddressVC = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddNewAddressVC else { return }
        let viewModel = AddNewAddressViewModel()
        addNewAddressVC.viewModell = viewModel
        navigationController.pushViewController(addNewAddressVC, animated: true)
    }
    
}
