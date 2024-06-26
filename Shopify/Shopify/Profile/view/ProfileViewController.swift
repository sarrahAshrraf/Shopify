
//  ProfileViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.


import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var guestModeView: UIView!
    @IBOutlet weak var welcomeUser: UILabel!
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var userStackView: UIStackView!
    
    @IBOutlet weak var orderStackView: UIStackView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var favouriteStackView: UIStackView!
    @IBOutlet weak var noInternetView: UIView!
    var profileViewModel: ProfileViewModel!
    var favouriteViewModel: FavoritesViewModel!
    var productDetailsViewModel = ProductDetailsViewModel()
    var internetConnectivity: ConnectivityManager?
    var orders: [Orders] = []
    var isGuestUser: Bool = false
    var index: Int = 0
    
    
    override func viewDidLoad() {
        print("viewDidLoad()")
        super.viewDidLoad()
        
        self.ordersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        self.favTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        getOrdersFromApi()
        favouriteViewModel = FavoritesViewModel()
        
        
        
        showFavouriteDetails()
        configureContainerView()
        configureContainerView2(stackView: orderStackView)
        configureContainerView2(stackView: favouriteStackView)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        setupNavigationBar()
        guard let state = UserDefaults.standard.string(forKey: Constants.KEY_USER_STATE) else { return }
        isGuestUser = (state == Constants.USER_STATE_GUEST)
        
        if isGuestUser {
            guestModeView.isHidden = false
            
        } else {
            guestModeView.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let customerName = UserDefaults.standard.string(forKey: Constants.USER_FirstName) {
            welcomeUser.text = "Welcome, \(customerName)!"
            userEmail.text = UserDefaults.standard.string(forKey: Constants.USER_Email)
        } else {
            welcomeUser.text = "Welcome!"
        }
        
        getOrdersFromApi()
        favouriteViewModel.getAllProducts()
        favTableView.reloadData()
        showFavouriteDetails()
        showNoIntenetView()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func showNoIntenetView(){
        internetConnectivity = ConnectivityManager.connectivityInstance
        if internetConnectivity?.isConnectedToInternet() == true {
            noInternetView.isHidden = true
        }else {
            noInternetView.isHidden = false
        }
    }
    
    func getOrdersFromApi() {
        let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)
        
        profileViewModel = ProfileViewModel()
        
        profileViewModel.bindOrdersToViewController = { [weak self] in
            self?.orders = self?.profileViewModel.result?.filter { $0.customer?.id == customerId } ?? []
            DispatchQueue.main.async {
                self?.ordersTableView.reloadData()
            }
            
        }
        profileViewModel.getOrders()
        
    }
    
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let backgroundImageView = UIImageView(image: UIImage(named: "no_product"))
        backgroundImageView.contentMode = .center
        if tableView == ordersTableView {
            //return min(orders.count, 2)
            if orders.count > 1 {
                ordersTableView.backgroundView = nil
                return 2
            }else if orders.count == 1 {
                ordersTableView.backgroundView = nil
                return 1
            }else {
                ordersTableView.backgroundView = backgroundImageView
            }
        }else if tableView == favTableView {
            if favouriteViewModel.allProductsList.count > 1 {
                favTableView.backgroundView = nil
                return 2
            }else if favouriteViewModel.allProductsList.count == 1 {
                favTableView.backgroundView = nil
                return 1
            }else {
                favTableView.backgroundView = backgroundImageView
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        145
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! CustomTableViewCell
            
            let order = orders[indexPath.row]
            cell.setOrderValues(order: order)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
            cell.setDataToTableCell(product: favouriteViewModel.allProductsList[indexPath.row])
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ordersTableView {
            let storyboard = UIStoryboard(name: "Order", bundle: nil)
            let orderVC = storyboard.instantiateViewController(withIdentifier: "OrdersDetailsViewController") as! OrdersDetailsViewController
            orderVC.modalPresentationStyle = .fullScreen
            orderVC.order = orders[indexPath.row]
            present(orderVC, animated: true)
        }else if tableView == favTableView {
            index = indexPath.row
            favouriteViewModel.getRemoteProducts()
            
        }
    }
    
    
    func showFavouriteDetails(){
        favouriteViewModel.bindResultToViewController = {[weak self] in
            guard let list = self?.favouriteViewModel.result else {return}
            guard let index = self?.index else {return}
            for product in list {
                if(product.id == self?.favouriteViewModel.allProductsList[index].id ?? 0){
                    self?.navigateToProductDetails(product: product)
                    break
                }
            }
        }
    }
    
    func navigateToProductDetails(product : Product){
        let products = UIStoryboard(name: "ProductDetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetailsViewController
    
        self.productDetailsViewModel.productId = product.id
        products.viewModel = self.productDetailsViewModel
        products.product = product
        products.modalPresentationStyle = .fullScreen
        self.present(products, animated: true)
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
        if UserDefault().getCustomerId() == -1 {
            Utilities.navigateToGuestScreen(viewController: self)
        }else {
            let storyboard = UIStoryboard(name: "ShoppingCartStoryboard", bundle: nil)
            let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            
            cartVC.modalPresentationStyle = .fullScreen
            cartVC.modalTransitionStyle = .crossDissolve
            present(cartVC , animated: true , completion: nil)
        }
    }
    
    
    @IBAction func moreOrdersBtn(_ sender: Any) {
        // Implement more orders action
        
        let ordersStoryBoard = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        ordersStoryBoard.modalPresentationStyle = .fullScreen
        ordersStoryBoard.modalTransitionStyle = .crossDissolve
        present(ordersStoryBoard , animated: true , completion: nil)
//        let navController = UINavigationController(rootViewController: ordersStoryBoard)
//        navController.modalPresentationStyle = .fullScreen
//        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func moreFavBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FavouriteStoryboard", bundle: nil)
        let favoriteVC = storyboard.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
        
        favoriteVC.modalPresentationStyle = .fullScreen
        favoriteVC.modalTransitionStyle = .crossDissolve
        present(favoriteVC, animated: true , completion: nil)
    }
    private func setupNavigationBar() {
        self.title = "Profile"
        let cartImage = UIImage(systemName: "cart")
        let cartButton = UIBarButtonItem(image: cartImage, style: .plain, target: self, action: #selector(cartButtonTapped))
        let settingsImage = UIImage(systemName: "gear")
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
  
        self.navigationItem.setRightBarButtonItems([settingsButton, cartButton], animated: true)
    }


    @objc private func cartButtonTapped() {
print("cart")
    }

    @objc private func settingsButtonTapped() {
        print("settin gs")


    }
    
    private func configureContainerView() {
        userStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        userStackView.isLayoutMarginsRelativeArrangement = true
        
        // Adding a custom view to the container with shadow
        userStackView.backgroundColor = UIColor(named: "CardColor")
        userStackView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        userStackView.layer.shadowOffset = .zero
        userStackView.layer.shadowOpacity = 0.2
        userStackView.layer.shadowRadius = 4
        userStackView.layer.cornerRadius = 15
    }
    
    
    private func configureContainerView2(stackView : UIStackView) {
        stackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // Adding a custom view to the container with shadow
        stackView.backgroundColor = UIColor(named: "CardColor")
        stackView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowOpacity = 0.2
        stackView.layer.shadowRadius = 3
        stackView.layer.cornerRadius = 15
    }
}
