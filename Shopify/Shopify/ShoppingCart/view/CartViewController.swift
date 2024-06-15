//
//  CartViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 11/06/2024.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , CartCellDelegate{
    
    @IBOutlet weak var emptyTableImg: UIImageView!
    
    @IBOutlet weak var checkOutBtn: UIButton!
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
    
    @IBAction func checkOutBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment_SB", bundle: nil)
        if let checkOutVC = storyboard.instantiateViewController(withIdentifier: "checkOutVC") as? CheckOutViewController {
            let navController = UINavigationController(rootViewController: checkOutVC)
            checkOutVC.total = cartPrice
//           navController.modalPresentationStyle = .fullScreen
           self.present(navController, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var priceLavel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    var cartPrice  = 0.0{
        didSet{
            priceLavel.text =  String(cartPrice)
        }
    }   
    var viewModel : ShoppingCartViewModel!
    var totalPrice = 0.0
    override func viewWillAppear(_ animated: Bool) {
        
       
        viewModel.showCartItems()
        viewModel.getCartItems()
        updateEmptyCartImageVisibility()
        showData()
        prepareCartPrice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        itemsTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
            viewModel = ShoppingCartViewModel()
        viewModel.showCartItems()
        viewModel.getCartItems()
        updateEmptyCartImageVisibility()
        showData()
       
        prepareCartPrice()

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
    
    func prepareCartPrice(){
        totalPrice = 0.0
        for item in CartList.cartItems {
            totalPrice += (Double(item.price!) ?? 0.0) * Double(item.quantity!)
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
        if let indexPath = itemsTableView.indexPath(for: cell) {
            let deletedItem = CartList.cartItems.remove(at: indexPath.row)
            viewModel.result?.line_items?.remove(at: indexPath.row)
            viewModel.editCart()
            itemsTableView.deleteRows(at: [indexPath], with: .fade)
            prepareCartPrice()
            updateEmptyCartImageVisibility()
            print("Deleted item: \(deletedItem)")
        }
    }
    

}
