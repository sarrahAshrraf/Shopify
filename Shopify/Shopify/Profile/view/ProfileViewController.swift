
//  ProfileViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.


import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var guestModeView: UIView!
    //
    //    @IBAction func backBtn(_ sender: Any) {
    //        self.navigationController?.popViewController(animated: true)
    //    }
    
    @IBOutlet weak var welcomeUser: UILabel!
    @IBAction func moreOrdersBtn(_ sender: Any) {
        // Implement more orders action
        
        let ordersStoryBoard = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        ordersStoryBoard.modalPresentationStyle = .fullScreen
        present(ordersStoryBoard, animated: true)
    }
    
    @IBAction func moreFavBtn(_ sender: Any) {
        // Implement more favorites action
    }
    
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    var profileViewModel: ProfileViewModel!
    var orders: [Orders] = []
    var isGuestUser: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        guard let state = UserDefaults.standard.string(forKey: Constants.KEY_USER_STATE) else { return }
        isGuestUser = (state == Constants.USER_STATE_GUEST)
        
        if isGuestUser {
            guestModeView.isHidden = false
            
        } else {
            guestModeView.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getOrdersFromApi()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        print("viewDidLoad()")
        super.viewDidLoad()
        
        self.ordersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        //        ordersTableView.delegate = self
        //        ordersTableView.dataSource = self
        getOrdersFromApi()
        print("Seeeeetingsssssssssssss")
        print(orders)
        print(orders.first?.customer)
        
        print(profileViewModel.result)
        print(profileViewModel.result?.first?.customer?.firstName)
    }
    
    func getOrdersFromApi() {
        let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)
        
        profileViewModel = ProfileViewModel()
        
        profileViewModel.bindOrdersToViewController = { [weak self] in
            self?.orders = self?.profileViewModel.result?.filter { $0.customer?.id == customerId } ?? []
            DispatchQueue.main.async {
                self?.ordersTableView.reloadData()
                self?.welcomeUser.text = "Welcome, \(self?.profileViewModel.result?.first?.customer?.firstName ?? "")!"
            }
            
        }
        profileViewModel.getOrders()
    }
    
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ordersTableView {
            return min(orders.count, 2)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! CustomTableViewCell
            
            let order = orders[indexPath.row]
            cell.setOrderValues(order: order)
            
            return cell
        }
        
        // Provide a default cell in case the tableView is not ordersTableView
        return UITableViewCell()
    }
    @IBAction func signUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
        
    }
    @IBAction func loginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
    }
    @IBAction func shoppingCartBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ShoppingCartStoryboard", bundle: nil)
        if let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            print("Could not find CartViewController in ShoppingCartStoryboard")
        }
    }
}
