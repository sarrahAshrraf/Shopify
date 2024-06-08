//
//  ProductDetailsViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit
import Kingfisher


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

        //viewModel = ProductDetailsViewModel()
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
            self?.productName.text = self?.viewModel.result?.title
            self?.descriptionLabel.text = self?.viewModel.result?.bodyHtml
            self?.price.text = self?.viewModel.result?.variants?.first?.price
            self?.productVendorAndType.text = (self?.viewModel.result?.vendor ?? "") + "," + (self?.viewModel.result?.productType ?? "")

            self?.productImage.kf.setImage(with: URL(string: self?.viewModel.result?.image?.src ?? " " ),
                                          placeholder: UIImage(named: Constants.noImage))
            self?.stockCount.text = "\(self?.viewModel.result?.variants?.first?.inventoryQuantity ?? 0)"

        }
      }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    

}
