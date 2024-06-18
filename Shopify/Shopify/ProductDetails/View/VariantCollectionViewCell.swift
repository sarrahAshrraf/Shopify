//
//  VariantCollectionViewCell.swift
//  Shopify
//
//  Created by Ahmed Refat on 18/06/2024.
//

import UIKit

class VariantCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var variantLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .white
    }
    
    override var frame: CGRect{
        get {
            return super.frame
        }
        set(newFrame){
            var frame = newFrame
            frame.origin.x += 8
            frame.origin.y += 8
            frame.size.width -= 2 * 8
            frame.size.height -= 2 * 8
            super.frame = frame
        }
    }
    
    func setColorData(color:String){
        print(color)
        variantLabel.text = color
    }
    
    func setSizeData(size:String){
        print(size)
        variantLabel.text = size
    }
}



