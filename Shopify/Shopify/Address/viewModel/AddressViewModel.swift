//
//  AddressViewModel.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import Foundation
class AddressViewModel{
    var bindToVC : ()->() = {}
    var bindDefaultAddress : (()->()) = {}
    //    var customers: [Customer] = [] {
    //        didSet{
    //          bindToVC()
    //        }
    //      }
    var addresses: [Address] = [] {
        didSet{
            bindToVC()
        }
    }
//    var address = OrderAddress()

    var defautltAdress : Address? {
        didSet{
          print(defautltAdress)
//          transferAddress()
          bindDefaultAddress()
//          fetchDeafultCustomerAddress(customerID: 7309504250029)

        }
      }
    
    func fetchCustomerAddress(customerID: Int) {
        //        let url = "https://349c94c1c855b8b029a39104a4ae2e13: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@mad44-alx-ios-team1.myshopify.com/admin/api/2024-01/customers/\(7309504250029)/addresses.json?limit=4"
        let url = URLs.shared.getAddressURL()
        NetworkManger.shared.getData(url: url) { response in
            if let response = response {
                self.addresses = response.addresses ?? []
                print("Fetched Addresses: \(response.addresses)")
            } else {
                print("Failed to fetch addresses")
            }
            
        }
    }
    func fetchDeafultCustomerAddress(customerID: Int) {
        let url = URLs.shared.getAddressURL()
        NetworkManger.shared.getData(url: url) { response in
            if let response = response {
                self.defautltAdress = response.addresses?.filter{ $0.default == true }.first 
              print("DEAFULT ADDRESSSSS")
                print(response.addresses?.filter{ $0.default == true }.first)
            } else {
                print("Failed to fetch addresses")
            }
            
        }
    }


    
    func deleteAddress(customerID: Int, addressID: Int, address: Address, completion: @escaping (Bool) -> Void) {
        let path = URLs.shared.getAddressURLForModification(customerID: String(7309504250029), addressID: String(addressID))
           NetworkManger.shared.deleteData(path: path) { success, statusCode in
               if success {
                   if let index = self.addresses.firstIndex(where: { $0.id == address.id }) {
                       self.addresses.remove(at: index)
                       self.bindToVC()
                       print("deelte in vm")
                   }
                   completion(true)
               } else {
                   print("not deleted")

                   completion(false)
               }
           }
       }
   }
    

