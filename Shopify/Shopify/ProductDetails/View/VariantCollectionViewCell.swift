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
        setup()
    }
    

    
    func setColorData(color:String){
        print(color)
        variantLabel.text = color
    }
    
    func setSizeData(size:String){
        print(size)
        variantLabel.text = size
    }
    
    private func setup() {
        // Button UI
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "VariantsColor")?.cgColor
        
    }
    
    func updateSelectionAppearance(isSelected: Bool) {
            if isSelected {
                contentView.backgroundColor = .black
                variantLabel.textColor = .white
            } else {
                contentView.backgroundColor = .white
                variantLabel.textColor = .black
            }
        }
}



