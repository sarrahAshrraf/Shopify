//  SettingsTableViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit
//MARK: user cart id

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var popUpBtn: UIButton!
    let defaults = UserDefaults.standard
    var currencies: [String]? = ["EGP", "USD", "EUR"]
    var viewModel: SettingsViewmodel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewmodel()
        setPopUpButton()
    
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           
           switch (indexPath.section, indexPath.row) {
           case (1, 0):
//               navigateToAddress()
               print("address")
           case (2, 0):
               print("logout")
               logout()
           default:
               break
           }
       }
    func navigateToAddress(){
        
                if let storyboard = UIStoryboard(name: "AddressStoryboard", bundle: nil).instantiateViewController(withIdentifier: "addressVC") as? AddressVC {
                    self.navigationController?.pushViewController(storyboard, animated: true)
                }
        
    }
    
    
    func logout() {

            let alert : UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive,handler: { [weak self] action in
                guard let my_Customer_id = UserDefaults.standard.string(forKey: Constants.customerId) else {return}
                self?.defaults.set(Constants.USER_STATE_LOGOUT, forKey: Constants.KEY_USER_STATE)
                //MARK: user cart id TODOOOOOOOOO

                self?.defaults.set("", forKey: Constants.customerId)
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
//                TODO: NAVIGTAE TO SPLASH SCREEN
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self?.present(nextViewController, animated: true, completion: nil)
                }
            ))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel,handler:nil))
            present(alert, animated: true, completion: nil)
          
            
//        }
   }
}

extension SettingsTableViewController  {
    func setPopUpButton(){
        var action :[UIAction] = []
        let optionSelected = {(action : UIAction) in
            print(action.title)
          self.viewModel.loadLatestCurrency(currency:  action.title)

        }
        guard let currencies = currencies else {return}
        if (currencies.isEmpty){
            action.append( UIAction(title: "currencies", handler: optionSelected) )
        } else {
            action = []
          var latestChosen = UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "USD"
          action.append(UIAction(title: latestChosen, handler: optionSelected))
            for item in currencies{
              if item != latestChosen{
                action.append( UIAction(title: item, handler: optionSelected))
              }
            }

        }

        popUpBtn.menu = UIMenu(children: action)
        popUpBtn.showsMenuAsPrimaryAction = true
        popUpBtn.changesSelectionAsPrimaryAction = true
    }
}
