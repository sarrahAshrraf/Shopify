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
            
        }
        searchViewModel.getItems()
    }
    
    func setupUI(){
        desPriceBtn.configureButton(selected: false)
        assPriiceBtn.configureButton(selected: false)
    }
    
    
    
    
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    
    
    

    @IBAction func sortPriceAscBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func sortPriceDesBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func showFilterView(_ sender: Any) {
        
        
    }
    

    
    @IBAction func sliderFilterBtn(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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




