//
//  ProductDetailsViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    var viewModel: ProductDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ProductDetailsViewModel()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        print("success")
        viewModel.getItems()
    }
    

    

}
