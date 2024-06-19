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
    var products: [Product] = []
    var productList: [Product] = []
    var defaults: UserDefaults!
    var filterFlag = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = UserDefaults.standard
        disposeBag = DisposeBag()
        searchViewModel = SearchViewModel()
        registerCell()
        bindData()
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
    
    func search() {
        searchBar.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
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
    
    
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    
    
    

    @IBAction func sortPriceAscBtn(_ sender: Any) {
        desPriceBtn.configureButton(selected: false)
        assPriiceBtn.configureButton(selected: true)
        products = products.sorted(by:  {Float($0.variants?[0].price ?? "") ?? 0 < Float($1.variants?[0].price ?? "") ?? 0})
        searchTableView.reloadData()
        
    }
    
    
    @IBAction func sortPriceDesBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func showFilterView(_ sender: Any) {
        
        
    }
    

    
    @IBAction func sliderFilterBtn(_ sender: Any) {
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




