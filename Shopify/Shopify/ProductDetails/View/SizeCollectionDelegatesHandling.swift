//
//  SizeCollectionDelegatesHandling.swift
//  Shopify
//
//  Created by Ahmed Refat on 18/06/2024.
//

import UIKit

class SizeCollectionDelegatesHandling: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var sizeArr:[String] = []
    var deselectThis:Int!
    var viewController:ProductDetailsViewController!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariantCollectionViewCell", for: indexPath) as! VariantCollectionViewCell
        cell.setSizeData(size: sizeArr[indexPath.row])
        if viewController.selectedSize == sizeArr[indexPath.row]{
            cell.addBorderAndRemoveShadow()
        } else {
            cell.elevateCellAndRemoveBorder()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController.selectedSize = sizeArr[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.addBorderAndRemoveShadow()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.elevateCellAndRemoveBorder()
    }
}


