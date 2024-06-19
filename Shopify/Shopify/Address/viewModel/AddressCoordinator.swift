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
   
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
    
    weak var viewController: UIViewController?

     init(viewController: UIViewController) {
         self.viewController = viewController
     }
    
    func showAddNewAddress(with address: Address?) { //show or edit address
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        guard let addNewAddressVC = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddNewAddressVC else { return }
        let viewModel = AddNewAddressViewModel(address: address)
        addNewAddressVC.viewModell = viewModel
        addNewAddressVC.isEditingAddress = true
        addNewAddressVC.addressID = address?.id
        addNewAddressVC.isDefaultAddress = address?.default ?? false
        addNewAddressVC.delegate =  viewController as! any AddressProtocol
        let navController = UINavigationController(rootViewController: addNewAddressVC)
                navController.modalPresentationStyle = .fullScreen
                viewController?.present(navController, animated: true, completion: nil)
            
        print("inside the show func \(addNewAddressVC.isEditingAddress) ")
        
//        navigationController.pushViewController(addNewAddressVC, animated: true)
    }
    
    func showAddNewAddressWithEmptyFields() { //add new one
        let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
        guard let addNewAddressVC = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddNewAddressVC else { return }
        let viewModel = AddNewAddressViewModel()
        addNewAddressVC.viewModell = viewModel
        addNewAddressVC.isEditingAddress = false
//        addNewAddressVC.addressID = address?.id
        
        addNewAddressVC.isDefaultAddress = false
        addNewAddressVC.checkOutDelegte = viewController as? AddressSelectionDelegate
        addNewAddressVC.delegate =  viewController as! any AddressProtocol
        let navController = UINavigationController(rootViewController: addNewAddressVC)
                navController.modalPresentationStyle = .fullScreen
                viewController?.present(navController, animated: true, completion: nil)
            
        print("inside the show func \(addNewAddressVC.isEditingAddress) ")

//        navigationController.pushViewController(addNewAddressVC, animated: true)
    }
    

    
    
    
    
    
    
//    func showAddressVC(delegate: AddressSelectionDelegate) {
//           let storyboard = UIStoryboard(name: "Address_SB", bundle: nil)
//           guard let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC") as? AddressVC else { return }
//           addressVC.delegate = delegate
//           addressVC.modalPresentationStyle = .fullScreen
//           navigationController.present(addressVC, animated: true, completion: nil)
//       }
    
}
