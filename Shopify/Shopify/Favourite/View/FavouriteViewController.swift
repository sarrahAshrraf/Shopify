//
//  FavouriteViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 14/06/2024.
//

import UIKit

class FavouriteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favouriteProductsTable: UITableView!
    var favouriteViewModel = FavoritesViewModel()
    var favouriteProducts: [LocalProduct] = []
    var defaults: UserDefaults = UserDefaults.standard
    var index: Int = 0
    static var staticFavoriteList: [LocalProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteProductsTable.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        favouriteViewModel.bindallProductsListToController = {[weak self] in
            guard let list = self?.favouriteViewModel.allProductsList else {return}
            for product in list {
                if(product.customer_id == self?.defaults.integer(forKey: Constants.customerId)){
                    self?.favouriteProducts.append(product)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouriteProducts = []
        favouriteViewModel.getAllProducts()
        checkIfThereAreFavoriteProducts(allProductsList: self.favouriteProducts)
        favouriteProductsTable.reloadData()
    }
   
    func checkIfThereAreFavoriteProducts(allProductsList:[LocalProduct]){
        favouriteProductsTable.isHidden = allProductsList.isEmpty
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        cell.setDataToTableCell(product: favouriteProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        145
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let alert = Alert().showRemoveProductFromFavoritesAlert(title: Constants.removeAlertTitle, msg: Constants.removeAlertMessage) {[weak self] action in
                let id  = self?.favouriteProducts[indexPath.row].id
                self?.favouriteViewModel.removeProduct(id: id!)
                self?.favouriteProducts.remove(at: indexPath.row)
                self?.favouriteProductsTable.reloadData()
                //self?.favouriteViewModel.getAllProducts()
                self?.checkIfThereAreFavoriteProducts(allProductsList: (self?.favouriteProducts)!)
            }
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        favouriteViewModel.getRemoteProducts()
    }
}
