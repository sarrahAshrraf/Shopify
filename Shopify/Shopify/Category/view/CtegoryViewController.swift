//
//  CtegoryViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 04/06/2024.
//

import UIKit
import Kingfisher

class CtegoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var categorySegmented: UISegmentedControl!
    
    var categoryViewModel: CategoryViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        categorySegmented.selectedSegmentIndex = 0
        categorySegmented.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)

        // Do any additional setup after loading the view.
        categoryViewModel = CategoryViewModel()
        
        fetchCategoryData()
        
    }
    @objc func segmentChanged(_ sender: UISegmentedControl) {
            fetchCategoryData()
        }
        
        func fetchCategoryData() {
            
            let categoryID: Int
            switch categorySegmented.selectedSegmentIndex {
            case 0:
                categoryID = 306236653741 // Man
            case 1:
                categoryID = 306236686509 // Women
            case 2:
                categoryID = 306236719277 // Kids
            case 3:
                categoryID = 306236752045 // Sell
            default:
                return
            }
            categoryViewModel?.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            categoryViewModel?.getItems(id: categoryID)
            collectionView.reloadData()
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let availableWidth = view.frame.width - (padding )
        let width = availableWidth / 2
        let height = width + 100
        
        return CGSize(width: width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel?.result.count ?? 0
    }

    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
         
         cell.setValues(product: self.categoryViewModel.result[indexPath.row])

         
        return cell
    }

    

}
