//
//  SearchViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 19/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var searchBar: RoundedTextfield!
    @IBOutlet weak var filteredPrice: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var desPriceBtn: UIButton!
    @IBOutlet weak var assPriiceBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    var disposeBag: DisposeBag!
    var searchViewModel: SearchViewModel!
    var productDetailsViewModel: ProductDetailsViewModel!
    var products: [Product] = []
    var productList: [Product] = []
    var defaults: UserDefaults!
    var filterFlag = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        disposeBag = DisposeBag()
        searchViewModel = SearchViewModel()
        productDetailsViewModel = ProductDetailsViewModel()
        registerCell()
        bindData()
        setSliderValues()
        setupUI()
        
    }
    
    func registerCell(){
        self.searchTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        priceSlider.isHidden = true
        filterView.isHidden = true
    }
    
    func bindData(){
        searchViewModel.bindResultToViewController = { [weak self] in
            self?.products = self?.searchViewModel.result ?? []
            self?.productList = self?.searchViewModel.result ?? []
            self?.search()
        }
        searchViewModel.getItems()
    }
    
    func setupUI(){
        desPriceBtn.configureButton(selected: false)
        assPriiceBtn.configureButton(selected: false)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
                
        cell.setProductToTableCell(product: products[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        145.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsVC = UIStoryboard(name: "ProductDetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetailsViewController
        productDetailsViewModel?.productId = products[indexPath.row].id
        productDetailsVC.product = products[indexPath.row]
        productDetailsVC.viewModel = productDetailsViewModel
        productDetailsVC.viewModel = productDetailsViewModel
        productDetailsVC.modalPresentationStyle = .fullScreen
        present(productDetailsVC, animated: true, completion: nil)
    }
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func search() {
        searchBar.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                setupUI()
                self.filter(searchText: text)
            })
            .disposed(by: disposeBag)
    }
    
    
    func filter(searchText:String) {
        if(!searchText.isEmpty){
            
            products = searchViewModel.result.filter{(Splitter().splitName(text: $0.title!, delimiter: "| ").lowercased().contains(searchText.lowercased()))}
            if products.isEmpty{
                products = []
            }
        }else {
            products = searchViewModel.result
        }
        self.searchTableView.reloadData()
        
    }
    
    
    

    @IBAction func sortPriceAscBtn(_ sender: Any) {
        desPriceBtn.configureButton(selected: false)
        assPriiceBtn.configureButton(selected: true)
        products = products.sorted(by:  {Float($0.variants?[0].price ?? "") ?? 0 < Float($1.variants?[0].price ?? "") ?? 0})
        searchTableView.reloadData()
    }
    
    
    @IBAction func sortPriceDesBtn(_ sender: Any) {
        desPriceBtn.configureButton(selected: true)
        assPriiceBtn.configureButton(selected: false)
        products = products.sorted(by:  {Float($0.variants?[0].price ?? "") ?? 0 > Float($1.variants?[0].price ?? "") ?? 0})
        searchTableView.reloadData()
    }
    
    
    @IBAction func showFilterView(_ sender: Any) {
        
        if filterFlag {
            priceSlider.isHidden = true
            filterView.isHidden = true
            if let heightConstraint = filterView.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.constant = 0
            }
            
        }else {
            priceSlider.isHidden = false
            filterView.isHidden = false
            
            if let heightConstraint = filterView.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.constant = UIScreen.main.bounds.height * 0.03
            }
        }
        filterFlag = !filterFlag
    }
    func filterBySlider(){
        products = productList.filter{Float($0.variants?[0].price ?? "") ?? 0 <= priceSlider.value}
        searchTableView.reloadData()
    }
    
    func setSliderValues() {
        // Array to store all variant prices
        var prices: [Double] = []

        // Loop through each product
        for product in products {
            // Loop through each variant of the product
            print("Insite Looop")
            for variant in product.variants ?? [] {
                print("Inside Loppppp2")
                if let price = Double(variant.price) {
                    prices.append(price)
                    print(price)
                }
            }
        }

        // Set the maximum and minimum values for the slider
        if let maxPrice = prices.max(), let minPrice = prices.min() {
            priceSlider.maximumValue = Float(maxPrice)
            priceSlider.minimumValue = Float(minPrice)
            print("Maximum price: \(maxPrice)")
            print("Minimum price: \(minPrice)")
        } else {
            // Handle case where prices array is empty
            priceSlider.maximumValue = 300
            priceSlider.minimumValue = 20
            print("No prices available.")
        }
    }

    
    @IBAction func sliderFilterBtn(_ sender: Any) {
        filteredPrice.text = "price: \(Int(priceSlider.value))"
        setupUI()
        filterBySlider()
    }
    
}


extension UIButton {
    func configureButton(selected: Bool) {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        
        if selected {
            self.backgroundColor = .black
            self.setTitleColor(.white, for: .normal)
        } else {
            self.backgroundColor = .white
            self.setTitleColor(.black, for: .normal)
        }
    }
}



