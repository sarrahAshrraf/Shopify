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

    func updateEmptyCartImageVisibility() {
        //        if ((viewModel.result?.line_items?.isEmpty) != nil) {
        
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
//                   present(navController, animated: true, completion: nil)
            present(navController, animated: true)
//            self.navigationController?.pushViewController(summaryVC, animated: true)
        } else {
            print("Could not find CartViewController in ShoppingCartStoryboard")
        }
    }
    
    
    @IBOutlet weak var priceLavel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    var cartPrice  = 0.0{
        didSet{
            priceLavel.text = String(format: "\(currencySymbol) %.2f", cartPrice)
        }
    }   
    var viewModel : ShoppingCartViewModel!
    var totalPrice = 0.0
    override func viewWillAppear(_ animated: Bool) {
        
        setupNavigationBar()
        updateEmptyCartImageVisibility()
        viewModel.showCartItems()
        viewModel.getCartItems()
        updateCartData()
//        showData()
//        prepareCartPrice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
//        setupNavigationBar()
        itemsTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        viewModel = ShoppingCartViewModel()
        viewModel.bindResultToViewController = { [weak self] in
                  self?.updateCartData()
              }
              updateCartData()
//        viewModel.showCartItems()
//        viewModel.getCartItems()
//        showData()
//        prepareCartPrice()
        
    }
    func updateCartData() {
        DispatchQueue.main.async {
            self.prepareCartPrice()
            self.itemsTableView.reloadData()
            self.updateEmptyCartImageVisibility()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func showData(){
        viewModel.bindResultToViewController = { [weak self] in
            
            DispatchQueue.main.async {
                //            self?.noItemsView.isHidden = true
                self?.itemsTableView.reloadData()
                
            }
        }
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
        return viewModel.result?.line_items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        if let lineItems = viewModel.result?.line_items {
            cell.delegate = self
            cell.setCartItemValues(lineItem: lineItems[indexPath.row], viewController: self)
            
            //        if let lineItems = viewModel.result?.lineItems {
            //                cell.configure(with: lineItems, index: indexPath.row)
            //            print("inside celllllllllll")
        }
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

    
//    func updateCartPrice() {
//        prepareCartPrice()
//    }
//    func deleteItem(_ cell: CartCell) {
//        if let indexPath = itemsTableView.indexPath(for: cell) {
//            let deletedItem = CartList.cartItems.remove(at: indexPath.row)
//            viewModel.result?.line_items?.remove(at: indexPath.row)
//            viewModel.editCart()
//            itemsTableView.deleteRows(at: [indexPath], with: .fade)
//            prepareCartPrice()
//            updateEmptyCartImageVisibility()
//            print("Deleted item: \(deletedItem)")
//        }
//    }
    

}
