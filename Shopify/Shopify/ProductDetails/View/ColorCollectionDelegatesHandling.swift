//
//  ColorCollectionDelegatesHandling.swift
//  Shopify
//
//  Created by Ahmed Refat on 18/06/2024.
//

import UIKit

class ColorCollectionDelegatesHandling: NSObject , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    var viewController:ProductDetailsViewController!
    
    var colorArr: [String] = []{
        willSet{
            for index in colorArr.indices {
                self.collectionView(viewController.productColorCollectionView, didDeselectItemAt: IndexPath(row: index, section: 0))
            }
            self.viewController.productColorCollectionView.reloadData()
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collllloooooooorrrr")
        print(colorArr.count)
        
        return colorArr.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariantCollectionViewCell", for: indexPath) as! VariantCollectionViewCell
        cell.setColorData(color: colorArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width/4-16, height: collectionView.frame.width/4-16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewController.selectedSize != nil {
            viewController.selectedColor = colorArr[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.addBorderAndRemoveShadow()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.elevateCellAndRemoveBorder()
    }
}




extension UICollectionViewCell {
    func elevateCellAndRemoveBorder (){
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        layer.shadowOpacity = 0.7
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.white.cgColor
    }
    
    func addBorderAndRemoveShadow (){
        layer.shadowRadius = 0.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.0
        contentView.layer.borderWidth = 4
        contentView.layer.borderColor = UIColor(named: "pink")?.cgColor
    }
    
}
