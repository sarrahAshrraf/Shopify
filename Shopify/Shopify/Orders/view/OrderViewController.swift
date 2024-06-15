//
//  OrderViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 01/06/2024.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let customerId = UserDefaults.standard.integer(forKey: Constants.customerId)

    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var profileViewModel: ProfileViewModel!
    var orders: [Orders] = []
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        getOrdersFromApi()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
    }
    func getOrdersFromApi() {
        profileViewModel = ProfileViewModel()
        profileViewModel.bindOrdersToViewController = { [weak self] in
            self?.orders = self?.profileViewModel.result?.filter { $0.customer?.id == self?.customerId } ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        profileViewModel.getOrders()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! CustomTableViewCell
        print(orders.count)
            let order = orders[indexPath.row]
            cell.setOrderValues(order: order)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier:"OrdersDetailsViewController") as! OrdersDetailsViewController
        storyboard.modalPresentationStyle = .fullScreen
        storyboard.order = orders[indexPath.row]
        present(storyboard, animated: true)
    }
    
    //    /*
    //    // MARK: - Navigation
    //
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //    }
    //    */
    //
    //}
}
