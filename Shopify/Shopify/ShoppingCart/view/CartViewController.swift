//
//  CartViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 11/06/2024.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        itemsTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
            viewModel = ShoppingCartViewModel()
        showData()
        prepareCartPrice()
        viewModel.showCartItems()
        viewModel.getCartItems()

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
        let count = viewModel.result?.lineItems?.count ?? 0
              print("Number of rows: \(count)")
        return viewModel.result?.lineItems?.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else {
               return UITableViewCell()
           }
                if let lineItems = viewModel.result?.lineItems {

        cell.setCartItemValues(lineItem: lineItems[indexPath.row], viewController: self)
//        if let lineItems = viewModel.result?.lineItems {
//                cell.configure(with: lineItems, index: indexPath.row)
//            print("inside celllllllllll")
            }
            return cell
        }
 

}
