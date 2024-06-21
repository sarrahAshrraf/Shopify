//
//  ProductReviewCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 20/06/2024.
//

import UIKit
import Cosmos

class ProductReviewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var reviewMessage: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
    }

    
    private func configureContainerView() {
        containerView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        containerView.isLayoutMarginsRelativeArrangement = true
        
        // Adding a custom view to the container with shadow
        containerView.backgroundColor = UIColor(named: "CardColor")
        containerView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
    }
    
    func setData(review: Review){
        photo.kf.setImage(with: URL(string: review.photo))
        personName.text = review.personName
        rating.rating = review.rate
        rating.settings.updateOnTouch = false
        reviewMessage.text = review.reviewMessage
    }
}
