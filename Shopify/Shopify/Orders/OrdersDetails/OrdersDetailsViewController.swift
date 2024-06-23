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
   
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    let navigationBar = UINavigationBar()
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        let defaults = UserDefaults.standard
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
    }
    func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
               
               let navigationItem = UINavigationItem(title: "Orders Details")
               
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "OrdersDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersDetailsTableViewCell")
        self.shopingTo.text = order?.customer?.firstName
        if let createdAtString = order?.createdAt {
            self.orderCreatedAt.text = Utilities.formatDateString(createdAtString)
        }
        self.orderAddress.text = order?.shippingAddress?.address1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.lineItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersDetailsTableViewCell", for: indexPath) as! OrdersDetailsTableViewCell
        print("count: \(order?.lineItems?.count ?? 0)")
        cell.orderProductName.text = order?.lineItems?[indexPath.row].title
        
        if let priceString = order?.lineItems?[indexPath.row].price, let price = Double(priceString), let orderCurrency = order?.currency {
                   let currencyRate: Double
                   let currencySymbol: String

                   switch orderCurrency {
                   case "EGP":
                       currencyRate = 47.707102
                       currencySymbol = "EGP"
                   case "USD":
                       currencyRate = 1.0
                       currencySymbol = "USD"
                   case "EUR":
                       currencyRate =  0.934102
                       currencySymbol = "EUR"
                   default:
                       currencyRate = 1.0
                       currencySymbol = orderCurrency
                   }
                   
                   let convertedPrice = price * currencyRate
            cell.orderProductPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
               } else {
                   cell.orderProductPrice.text = order?.lineItems?[indexPath.row].price
               }
//        cell.orderProductPrice.text = order?.lineItems?[indexPath.row].price
        cell.orderProductQuntity.text = "Quantity : \(order?.lineItems?[indexPath.row].quantity ?? 0)"
        cell.orderProductImageView.kf.setImage(with: URL(string: String(order?.lineItems?[indexPath.row].properties?[0].value?.split(separator: "$")[0] ?? "No Image")))
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
