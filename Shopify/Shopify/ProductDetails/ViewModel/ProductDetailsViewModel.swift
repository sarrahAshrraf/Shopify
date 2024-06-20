//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import Foundation

class ProductDetailsViewModel {
    
    var productId:Int = 0
    var bindResultToViewController: (()->()) = {}
    var result: Product? {
        didSet{
            self.bindResultToViewController()
        }
    }
   
    func getItems(){

        let url = URLs.shared.productDetails(id: productId)
        
        NetworkManger.shared.getData(url: url){ [weak self] (response : Response?) in
            self?.result = (response?.product)!
            print(self?.result)
        }
    }
}


extension ProductDetailsViewModel{
    
    static let Reviews: [Review] = [
        Review(photo: "https://banner2.cleanpng.com/20180430/vcq/kisspng-computer-icons-avatar-encapsulated-postscript-tomato-face-5ae78e3c71e6a4.0699443615251246684666.jpg", personName: "Ahmed Refat", rate: 5, reviewMessage: "I liked this product, it is perfect"),
        Review(photo: "https://banner2.cleanpng.com/20180612/hv/kisspng-computer-icons-designer-avatar-5b207ebb279901.8233901115288562511622.jpg", personName: "Sarrah Ashraf", rate: 4.5, reviewMessage: "High quality with low price"),
        Review(photo: "https://banner2.cleanpng.com/20180430/vcq/kisspng-computer-icons-avatar-encapsulated-postscript-tomato-face-5ae78e3c71e6a4.0699443615251246684666.jpg", personName: "Mohamed Kotb", rate: 3.2, reviewMessage: "Very expensive with low quality."),
        Review(photo: "https://banner2.cleanpng.com/20180430/vcq/kisspng-computer-icons-avatar-encapsulated-postscript-tomato-face-5ae78e3c71e6a4.0699443615251246684666.jpg", personName: "Ahmed Khaled", rate: 2.5, reviewMessage: "Bad Product."),
        Review(photo: "https://banner2.cleanpng.com/20180430/vcq/kisspng-computer-icons-avatar-encapsulated-postscript-tomato-face-5ae78e3c71e6a4.0699443615251246684666.jpg", personName: "Mina Emad", rate: 3.8, reviewMessage: "Good Product.")
    ]
}

