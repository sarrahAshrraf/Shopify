//
//  BrandViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit

class BrandViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var viewModel: BrandProductsViewModel!
    var favoritesViewModel: FavoritesViewModel!
    var productDetailsViewModel: ProductDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        productsCollectionView.register(UINib(nibName: "BrandProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandProductCollectionViewCell")
        
        //viewModel = BrandProductsViewModel()
        productDetailsViewModel = ProductDetailsViewModel()
        favoritesViewModel = FavoritesViewModel()
        fetchData()
        showData()

        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        print("success")
        viewModel.getItems()
    }
    func showData(){
      viewModel.bindResultToViewController = { [weak self] in

        DispatchQueue.main.async {
          
          self?.productsCollectionView.reloadData()

        }
      }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandProductCollectionViewCell" , for: indexPath) as! BrandProductCollectionViewCell
//        cell.setValues(product: self.viewModel.result[indexPath.row],isFav: favoritesViewModel.checkIfProductIsFavorite(productId: self.viewModel.result[indexPath.row].id, customerId: UserDefaults.standard.integer(forKey: Constants.customerId)), viewcontroller: self)
//
//        
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandProductCollectionViewCell", for: indexPath) as! BrandProductCollectionViewCell
            let product = self.viewModel.result[indexPath.row]
            let isFav = favoritesViewModel.checkIfProductIsFavorite(productId: product.id, customerId: UserDefaults.standard.integer(forKey: Constants.customerId))
            cell.setValues(product: product, isFav: isFav, viewController: self)
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: UIScreen.main.bounds.height/4)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let products = UIStoryboard(name: "ProductDetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetailsViewController
        productDetailsViewModel?.productId = viewModel?.result[indexPath.row].id ?? 0
        products.product = viewModel?.result[indexPath.row]
        //print(viewModel?.result[indexPath.row])
        
        products.viewModel = productDetailsViewModel
        products.modalPresentationStyle = .fullScreen
        present(products, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

