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
    var cartVM = ShoppingCartViewModel()
    var isGuestUser: Bool = false
    var lineItems:[LineItems]!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewmodel()
        lineItems = []
        setPopUpButton()
        // Check user state and set guest mode
               guard let state = UserDefaults.standard.string(forKey: Constants.KEY_USER_STATE) else { return }
               isGuestUser = (state == Constants.USER_STATE_GUEST)
               
               if isGuestUser {
                   hideAllStaticRows()
                   updateBackgroundView()
//                   setTableBackgroundImage()
               }
           }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return isGuestUser ? 0 : 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isGuestUser {
             return 0
         }
         
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
        if isGuestUser {
                   return
               }

               switch (indexPath.section, indexPath.row) {
               case (1, 0):
//                   navigateToAddress()
                   print("AddressStoryboard")
               case (2, 0):
                   logout()
               default:
                   break
               }
           }
    func navigateToAddress(){
        
                if let storyboard = UIStoryboard(name: "Address_SB", bundle: nil).instantiateViewController(withIdentifier: "addressVC") as? AddressVC {
                    self.navigationController?.pushViewController(storyboard, animated: true)
                }
        
    }
    
    
    func logout() {
        
            let alert : UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive,handler: { [weak self] action in
                guard let my_Customer_id = UserDefaults.standard.string(forKey: Constants.customerId) else {return}
                self?.defaults.set(Constants.USER_STATE_GUEST, forKey: Constants.KEY_USER_STATE)
                //MARK: user cart id TODOOOOOOOOO

                
                CartList.cartItems = []
                self?.cartVM.editCart()
                self?.defaults.set("", forKey: Constants.cartId)
                self?.defaults.set("", forKey: Constants.customerId)
                self?.defaults.set("", forKey: Constants.CURRENCY_KEY)
                self?.defaults.set("", forKey: Constants.CURRENCY_VALUE)    
                
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
//                TODO: NAVIGTAE TO SPLASH SCREEN
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self?.present(nextViewController, animated: true, completion: nil)
                }
            ))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel,handler:nil))
            present(alert, animated: true, completion: nil)
          
            
        }
   
    func hideAllStaticRows() {
           tableView.reloadData()
       }

//    func setTableBackgroundImage() {
//        let backgroundImage = UIImage(named: "signUp")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.contentMode = .scaleAspectFit
//
//        let containerView = UIView(frame: tableView.bounds)
//        imageView.frame = containerView.bounds
//        let label = UILabel()
//        label.text = "Sign up first please."
//        label.textAlignment = .center
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(imageView)
//        containerView.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 100)
//        ])
//
//        tableView.backgroundView = containerView
//    }
    private func updateBackgroundView() {
       
            let signUpLabel = UILabel()
        signUpLabel.text = "Please, sign up first."
        signUpLabel.textColor = .gray
        signUpLabel.numberOfLines = 0
        signUpLabel.textAlignment = .center
        signUpLabel.font = UIFont.systemFont(ofSize: 16)
        signUpLabel.sizeToFit()
            tableView.backgroundView = signUpLabel
       
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

