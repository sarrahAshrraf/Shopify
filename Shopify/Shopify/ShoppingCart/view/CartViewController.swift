//
//  CartViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 11/06/2024.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , CartCellDelegate{
    @IBOutlet weak var emptyTableImg: UIImageView!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    @IBOutlet weak var checkOutBtn: UIButton!
    let navigationBar = UINavigationBar()
//    var activityIndicator = UIActivityIndicatorView(style: .large)

    func updateEmptyCartImageVisibility() {
        if CartList.cartItems.isEmpty {
            emptyTableImg.isHidden = false
            itemsTableView.isHidden = true
            checkOutBtn.isHidden = true
            totalPriceLabel.isHidden = true
            priceLavel.isHidden = true
        } else {
            emptyTableImg.isHidden = true
            itemsTableView.isHidden = false
            checkOutBtn.isHidden = false
            totalPriceLabel.isHidden = false
            priceLavel.isHidden = false
        }
    }
    
    func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem(title: "Cart")
        
        if let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
        
        navigationBar.items = [navigationItem]
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction func checkOutBtn(_ sender: Any) {
        if let summaryVC = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController {
            summaryVC.total = cartPrice
            summaryVC.modalPresentationStyle = .fullScreen
            let navController = UINavigationController(rootViewController: summaryVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        } else {
            print("Could not find SummaryViewController in storyboard")
        }
    }
    
    @IBOutlet weak var priceLavel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    var cartPrice = 0.0 {
        didSet {
            priceLavel.text = String(format: "\(currencySymbol) %.2f", cartPrice)
        }
    }
    var viewModel: ShoppingCartViewModel!
    var totalPrice = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        updateEmptyCartImageVisibility()
        viewModel.showCartItems() // Ensure fetching of cart items
        updateCartData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(activityIndicator)
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        viewModel = ShoppingCartViewModel()
        viewModel.bindResultToViewController = { [weak self] in
            self?.updateCartData()
        }
        viewModel.showCartItems() // Fetch items as soon as the view loads
//        showLoadingIndicator()
    }
    
//    func showLoadingIndicator() {
//        activityIndicator.startAnimating()
//        itemsTableView.isHidden = true
//        checkOutBtn.isHidden = true
//        totalPriceLabel.isHidden = true
//        priceLavel.isHidden = true
//    }
//
//    func hideLoadingIndicator() {
//        activityIndicator.stopAnimating()
//        itemsTableView.isHidden = false
//        checkOutBtn.isHidden = false
//        totalPriceLabel.isHidden = false
//        priceLavel.isHidden = false
//    }
    
    func updateCartData() {
        DispatchQueue.main.async {
            self.prepareCartPrice()
            self.itemsTableView.reloadData()
            self.updateEmptyCartImageVisibility()
//            self.hideLoadingIndicator()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func prepareCartPrice() {
        totalPrice = 0.0
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }

        for item in CartList.cartItems {
            if let itemPrice = Double(item.price ?? "0.0"), let itemQuantity = item.quantity {
                totalPrice += (itemPrice * currencyRate) * Double(itemQuantity)
            }
        }
        cartPrice = totalPrice
        itemsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.result?.line_items?.count ?? 0
        print("Number of rows: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        let properties = [Properties(name: "image_url", value: "")]
        let dummy = LineItems(price: "20.0", quantity: 1, title: "dummy", properties:properties)

        let item = viewModel.result?.line_items?[indexPath.row] ?? dummy
        
//        CartList.cartItems[indexPath.row]
        cell.delegate = self
        cell.setCartItemValues(lineItem: item, viewController: self)
        return cell
    }
    
    func deleteItem(_ cell: CartCell) {
        guard let indexPath = itemsTableView.indexPath(for: cell) else { return }
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let deletedItem = CartList.cartItems.remove(at: indexPath.row)
            self.viewModel.result?.line_items?.remove(at: indexPath.row)
            self.viewModel.editCart()
            self.itemsTableView.deleteRows(at: [indexPath], with: .fade)
            self.prepareCartPrice()
            self.updateEmptyCartImageVisibility()
            print("Deleted item: \(deletedItem)")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
