//  SettingsTableViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
           case 0:
               return 1 // currency cell
           case 1:
               return 2 // addresses and about us cells
           case 2:
               return 1 // logout cell
           default:
               return 0
           }
       }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           switch (indexPath.section, indexPath.row) {
//           case (0, 0):
//               let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
//               return cell
//           case (1, 0):
//               let cell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath)
//               cell.textLabel?.text = "Addresses"
//               return cell
//           case (1, 1):
//               let cell = tableView.dequeueReusableCell(withIdentifier: "aboutUsCell", for: indexPath)
//               cell.textLabel?.text = "About Us"
//               return cell
//           case (2, 0):
//               let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
//               cell.textLabel?.text = "Logout"
//               return cell
//           default:
//               fatalError("Unknown section/row combination")
//           }
//       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           
           switch (indexPath.section, indexPath.row) {
           case (1, 0):
//               navigateToAddress()
               print("address")
           case (2, 0):
               print("logout")
           default:
               break
           }
       }
    func navigateToAddress(){
        
                if let storyboard = UIStoryboard(name: "AddressStoryboard", bundle: nil).instantiateViewController(withIdentifier: "addressVC") as? AddressVC {
                    self.navigationController?.pushViewController(storyboard, animated: true)
                }
        
    }
}
