//
//  ReviewsDelegatesHandling.swift
//  Shopify
//
//  Created by Ahmed Refat on 20/06/2024.
//

import UIKit

class ReviewsDelegatesHandling: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var viewController: ProductDetailsViewController!
    var productReviews: [Review] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductReviewCell") as! ProductReviewCell
        cell.setData(review: productReviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
   
}
