//
//  CategoryViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 08/06/2024.
//

import UIKit
import Kingfisher
import Dispatch

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
    
    var prices : [String] = []
    
    
    
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
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCategoryData()
        //fetchPrice()
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        fetchCategoryData()
    }
            
    

    
    func fetchPrice() {
        
        guard let categoryViewModel = self.categoryViewModel else { return }
        
        let group = DispatchGroup()
        
        for i in 0..<categoryViewModel.result.count {
            let productId = categoryViewModel.result[i].id
            group.enter()
            
            categoryViewModel.getPrice(productId: productId) { fetchedProduct in
                if let product = fetchedProduct, !categoryViewModel.result.contains(where: { $0.id == product.id }) {
                    categoryViewModel.result.append(product)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // This block will execute when all network requests are done
            // You can perform any updates to the UI or other actions here
            print("All prices fetched and processed")
        }
    }

            
            func fetchCategoryData() {
                
                let categoryID: Int
                switch categorySegmented.selectedSegmentIndex {
                case 0:
//                    self.categoryViewModel.result = []
                    categoryID = 306236653741 // Man
                    //fetchPrice()
                    self.categoryViewModel?.getItems(id: categoryID)
//                    fetchPrice()
                case 1:
//                    self.categoryViewModel.result = []
                    //fetchPrice()
                    categoryID = 306236686509 // Women
                    self.categoryViewModel?.getItems(id: categoryID)
                    
                case 2:
//                    self.categoryViewModel.result = []
                    //fetchPrice()
                    categoryID = 306236719277 // Kids
                    self.categoryViewModel?.getItems(id: categoryID)
                    
                case 3:
//                    self.categoryViewModel.result = []
                    //fetchPrice()
                    categoryID = 306236752045 // Sell
                    self.categoryViewModel?.getItems(id: categoryID)
                default:
                    return
                }
                categoryViewModel?.bindResultToViewController = { [weak self] in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
//                    self?.categoryViewModel?.getItems(id: categoryID)
                    
                }
                self.fetchPrice()
                
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
