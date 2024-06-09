//
//  CategoryViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 08/06/2024.
//

import UIKit
import Kingfisher

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    let defaultColor = UIColor.black
    let selectedColor = UIColor.gray
    //var originalResult: [Product] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categorySegmented: UISegmentedControl!
    @IBOutlet weak var subCategoryToolbar: UIToolbar!
    @IBOutlet weak var allProduct: UIBarButtonItem!
    @IBOutlet weak var shoes: UIBarButtonItem!
    @IBOutlet weak var t_shirt: UIBarButtonItem!
    @IBOutlet weak var accesories: UIBarButtonItem!
    var isFiltered:Bool!
    
    var categoryViewModel: CategoryViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        categoryViewModel = CategoryViewModel()
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        categorySegmented.selectedSegmentIndex = 0
        categorySegmented.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
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
                //collectionView.reloadData()
            }
    
    
    @IBAction func allProduct(_ sender: UIBarButtonItem) {
        updateButtonColors(selectedButton: sender)
        isFiltered = true
        categoryViewModel.filteredProducts = categoryViewModel.result
        collectionView.reloadData()
    }
    @IBAction func shoes(_ sender: UIBarButtonItem) {
        updateButtonColors(selectedButton: sender)
        isFiltered = true
        categoryViewModel.filteredProducts = categoryViewModel.result.filter{$0.productType == "SHOES"}
        collectionView.reloadData()
    }
    
    @IBAction func t_shirt(_ sender: UIBarButtonItem) {
        updateButtonColors(selectedButton: sender)
        isFiltered = true
        categoryViewModel.filteredProducts = categoryViewModel.result.filter{$0.productType == "T-SHIRTS"}
        collectionView.reloadData()
    }
    @IBAction func accesories(_ sender: UIBarButtonItem) {
        updateButtonColors(selectedButton: sender)
        isFiltered = true
        categoryViewModel.filteredProducts = categoryViewModel.result.filter{$0.productType == "ACCESSORIES"}
        collectionView.reloadData()
    }
    
    func updateButtonColors(selectedButton: UIBarButtonItem) {
        // Reset all buttons to default color
        allProduct.tintColor = defaultColor
        shoes.tintColor = defaultColor
        t_shirt.tintColor = defaultColor
        accesories.tintColor = defaultColor
        
        // Set the selected button color
        selectedButton.tintColor = selectedColor
    }
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (isFiltered == true){
            return categoryViewModel.filteredProducts.count
        } else {
            return categoryViewModel?.result.count ?? 0
        }
    }


    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
         if(isFiltered == true){
             cell.setValues(product: self.categoryViewModel.filteredProducts[indexPath.row])
         }else{
             cell.setValues(product: self.categoryViewModel.result[indexPath.row])
         }

         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 10, height: UIScreen.main.bounds.height/4)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
