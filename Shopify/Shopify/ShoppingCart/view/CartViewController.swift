//
//  CartViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 11/06/2024.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var priceLavel: UILabel!
    
    @IBOutlet weak var noItemsView: UIImageView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    var viewModel : ShoppingCartViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        itemsTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
            viewModel = ShoppingCartViewModel()
        showData()
        viewModel.getCartItems()
    }
    
    func showData(){
      viewModel.bindResultToViewController = { [weak self] in

        DispatchQueue.main.async {
            self?.noItemsView.isHidden = true
          self?.itemsTableView.reloadData()

        }
      }
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.result?.lineItems?.count ?? 0
              print("Number of rows: \(count)")
        return viewModel.result?.lineItems?.count ?? 0
    }
   

//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
//           if let lineItem = viewModel.result?.lineItems?[indexPath.row] {
//               cell.titleLabel.text = lineItem.title
//               cell.priceLabel.text = lineItem.price
//               print(lineItem.title)
//           }
//           return cell
//       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else {
               return UITableViewCell()
           }
        if let lineItems = viewModel.result?.lineItems {
                cell.configure(with: lineItems, index: indexPath.row)
            print("inside celllllllllll")
            }
            return cell
        }
 

}
