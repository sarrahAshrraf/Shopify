//
//  ReviewViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 21/06/2024.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var productReviewsTableView: UITableView!
    var reviewsList:[Review] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        productReviewsTableView.register(UINib(nibName:"ProductReviewCell" , bundle: nil), forCellReuseIdentifier: "ProductReviewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductReviewCell") as! ProductReviewCell
        cell.setData(review: reviewsList[indexPath.row])
        return cell
    }
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
