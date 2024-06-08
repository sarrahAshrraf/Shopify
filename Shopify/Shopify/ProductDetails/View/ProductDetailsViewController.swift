//
//  ProductDetailsViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit


class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productVendorAndType: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stockCount: UILabel!
    
    var viewModel: ProductDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ProductDetailsViewModel()
        //fetchData()
        // Do any additional setup after loading the view.
    }
    
//    func fetchData(){
//        print("success")
//        viewModel.getItems()
//    }
    

    

}
