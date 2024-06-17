//
//  OrdersDetailsViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 13/06/2024.
//

import UIKit
import Kingfisher

class OrdersDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderCreatedAt: UILabel!
    
    @IBOutlet weak var shopingTo: UILabel!
    
    var order: Orders?
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var orderAddress: UILabel!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "OrdersDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersDetailsTableViewCell")
        self.shopingTo.text = order?.customer?.firstName
        self.orderCreatedAt.text = order?.createdAt
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.lineItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersDetailsTableViewCell", for: indexPath) as! OrdersDetailsTableViewCell
        print("count: \(order?.lineItems?.count ?? 0)")
        cell.orderProductName.text = order?.lineItems?[indexPath.row].title
        cell.orderProductPrice.text = order?.lineItems?[indexPath.row].price
        cell.orderProductQuntity.text = "\(order?.lineItems?[indexPath.row].quantity ?? 0)"
        print(order?.lineItems?[indexPath.row].title)
        print(order?.lineItems?[indexPath.row].price)
        print("\(order?.lineItems?[indexPath.row].quantity ?? 0)")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180 // An estimated height
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
