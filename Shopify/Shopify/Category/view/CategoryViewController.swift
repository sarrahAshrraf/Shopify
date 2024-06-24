import UIKit
import Kingfisher
import Dispatch

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let defaultColor = UIColor.black
    let selectedColor = UIColor.white
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categorySegmented: UISegmentedControl!
    @IBOutlet weak var subCategoryToolbar: UIToolbar!
    @IBOutlet weak var allProduct: UIButton!
    @IBOutlet weak var shoes: UIButton!
    @IBOutlet weak var t_shirt: UIButton!
    @IBOutlet weak var accesories: UIButton!
    
    
    
    var currencySymbol: String = "USD"
    
    var productDetailsViewModel: ProductDetailsViewModel!
    
    var currencyRate: Double = 1.0
    var isFiltered: Bool = false
    var allProducts: [Product] = []
    var categoryViewModel: CategoryViewModel!
    var favoritesViewModel: FavoritesViewModel!
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ////////
        activityIndicator = UIActivityIndicatorView(style: .large)
               activityIndicator.center = self.view.center
               self.view.addSubview(activityIndicator)
        /////////
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        categoryViewModel = CategoryViewModel()
        productDetailsViewModel = ProductDetailsViewModel()
        favoritesViewModel = FavoritesViewModel()
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        categorySegmented.selectedSegmentIndex = 0
        categorySegmented.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        updateSegmentedControlColors()
        fetchCategoryData()
        setupUI()
    }
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
        print(currencySymbol)
        categoryViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                ////////
                if ((self?.categoryViewModel.checkInternetConnectivity()) != nil){
                    self?.activityIndicator.stopAnimating()
                    
                    self?.collectionView.reloadData()
                } else {
                    self?.activityIndicator.startAnimating()
                    self?.showNoInternetAlert()
                    self?.collectionView.reloadData()
                    
                }
                
            }
        }
        
        self.categoryViewModel.getAllProducts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.categoryViewModel.checkInternetConnectivity() {
                self.fetchCategoryData()
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            } else {
                self.showNoInternetAlert()
                self.collectionView.reloadData()
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        updateSegmentedControlColors()
        if self.categoryViewModel.checkInternetConnectivity() {
            fetchCategoryData()
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        } else {
            self.showNoInternetAlert()
            self.collectionView.reloadData()
            self.activityIndicator.startAnimating()
        }
    }
    
    func updateSegmentedControlColors() {
            let selectedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: selectedColor]
            let defaultAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: defaultColor]
            
            for index in 0..<categorySegmented.numberOfSegments {
                if index == categorySegmented.selectedSegmentIndex {
                    categorySegmented.setTitleTextAttributes(selectedAttributes, for: .selected)
                } else {
                    categorySegmented.setTitleTextAttributes(defaultAttributes, for: .normal)
                }
            }
        }
    
    func fetchCategoryData() {
        print("Segment Index: \(categorySegmented.selectedSegmentIndex)")
        
        var tag: String
        
        switch categorySegmented.selectedSegmentIndex {
        case 0:
            tag = " men"
        case 1:
            tag = " women"
        case 2:
            tag = "kid"
        case 3:
            tag = "sale"
        default:
            return
        }
        
        print("Filtering products with tag: \(tag)")
        
        allProducts = getProductsWithTag(products: categoryViewModel.result, tag: tag)
        
        categoryViewModel.filteredProducts = allProducts
        collectionView.reloadData()
        
        print("Filtered products count: \(allProducts.count)")
        
        DispatchQueue.main.async {
            if self.categoryViewModel.checkInternetConnectivity(){
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            } else {
                self.showNoInternetAlert()
                self.collectionView.reloadData()
                self.activityIndicator.startAnimating()
            }
            print("Collection view reloaded")
        }
    }
    
    func getProductsWithTag(products: [Product], tag: String) -> [Product] {
        return products.filter { product in
            return product.tags?.contains(tag) ?? false
        }
    }
    
    @IBAction func allProductSectionBtn(_ sender: Any) {
        updateButtonColors(selectedButton: allProduct)
        isFiltered = false
        collectionView.reloadData()
    }
    
    @IBAction func shoesSectionBtn(_ sender: Any) {
        updateButtonColors(selectedButton: shoes)
        isFiltered = true
        categoryViewModel.filteredProducts = allProducts.filter { $0.productType == "SHOES" }
        collectionView.reloadData()
    }
    
    @IBAction func t_shirtSectionBtn(_ sender: Any) {
        updateButtonColors(selectedButton: t_shirt)
        isFiltered = true
        categoryViewModel.filteredProducts = allProducts.filter { $0.productType == "T-SHIRTS" }
        
        collectionView.reloadData()
    }
    
    @IBAction func accesoriesSectionBtn(_ sender: Any) {
        updateButtonColors(selectedButton: accesories)
        isFiltered = true
        categoryViewModel.filteredProducts = allProducts.filter { $0.productType == "ACCESSORIES" }
        print("Filtered products count: \(categoryViewModel.filteredProducts.count)")
        //checkForProductsCount()
        
        collectionView.reloadData()
    }
    
    func checkForProductsCount(){
        if categoryViewModel.filteredProducts.count == 0 {
                collectionView.isHidden = true
                if let existingNoDataView = self.view.viewWithTag(999) as? UIImageView {
                    existingNoDataView.removeFromSuperview()
                }

                let noProductImg = UIImageView()
                noProductImg.tag = 999
                noProductImg.image = UIImage(named: "no_product")
                noProductImg.contentMode = .scaleAspectFit
                noProductImg.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(noProductImg)

                NSLayoutConstraint.activate([
                    noProductImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    noProductImg.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    noProductImg.widthAnchor.constraint(equalToConstant: 250),
                    noProductImg.heightAnchor.constraint(equalToConstant: 250)
                ])
            } else {
                if let existingNoDataView = self.view.viewWithTag(999) as? UIImageView {
                    existingNoDataView.removeFromSuperview()
                }
                collectionView.isHidden = false
                
            }
    }

    func setupUI(){
        allProduct.configureButton(selected: false)
        shoes.configureButton(selected: false)
        t_shirt.configureButton(selected: false)
        accesories.configureButton(selected: false)
    }
    
    func updateButtonColors(selectedButton: UIButton) {
        setupUI()
        selectedButton.configureButton(selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltered {
            if categoryViewModel.filteredProducts.count == 0{
                checkForProductsCount()
                return 0
            } else {
                checkForProductsCount()
                collectionView.isHidden = false
                return categoryViewModel.filteredProducts.count
            }
            
        } else {
            return allProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        
        if isFiltered {
            cell.setValues(product: self.categoryViewModel.filteredProducts[indexPath.row],isFav: favoritesViewModel.checkIfProductIsFavorite(productId: self.categoryViewModel.filteredProducts[indexPath.row].id, customerId: UserDefaults.standard.integer(forKey: Constants.customerId)))
            if let variant = self.categoryViewModel.filteredProducts[indexPath.row].variants?.first {
                if let price = Double(variant.price) {
                    let convertedPrice = price * currencyRate
                    cell.productPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
                }
            }
        } else {
            cell.setValues(product: self.allProducts[indexPath.row],isFav: favoritesViewModel.checkIfProductIsFavorite(productId: self.allProducts[indexPath.row].id, customerId: UserDefaults.standard.integer(forKey: Constants.customerId)))
            if let variant = self.allProducts[indexPath.row].variants?.first {
                if let price = Double(variant.price) {
                    let convertedPrice = price * currencyRate
                    cell.productPrice.text = String(format: "%.2f %@", convertedPrice, currencySymbol)
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let products = UIStoryboard(name: "ProductDetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetailsViewController
        if isFiltered{
            productDetailsViewModel?.productId = self.categoryViewModel.filteredProducts[indexPath.row].id
            products.product = self.categoryViewModel.filteredProducts[indexPath.row]
        } else {
            productDetailsViewModel?.productId = self.allProducts[indexPath.row].id
            products.product = self.allProducts[indexPath.row]
        }
        //print(viewModel?.result[indexPath.row])
        
        products.viewModel = productDetailsViewModel
        products.modalPresentationStyle = .fullScreen
        present(products, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.height / 4)
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
    
    
    @IBAction func navigateToFavorite(_ sender: UIButton) {
        if UserDefault().getCustomerId() == -1 {
            Utilities.navigateToGuestScreen(viewController: self)
        }else {
            let storyboard = UIStoryboard(name: "FavouriteStoryboard", bundle: nil)
            let favoriteVC = storyboard.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
            
            favoriteVC.modalPresentationStyle = .fullScreen
            favoriteVC.modalTransitionStyle = .crossDissolve
            present(favoriteVC, animated: true , completion: nil)
        }
        
    }
    
    @IBAction func navigateToCart(_ sender: Any) {
        if UserDefault().getCustomerId() == -1 {
            Utilities.navigateToGuestScreen(viewController: self)
        }else {
            let storyboard = UIStoryboard(name: "ShoppingCartStoryboard", bundle: nil)
            let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                
            cartVC.modalPresentationStyle = .fullScreen
            cartVC.modalTransitionStyle = .crossDissolve
            present(cartVC , animated: true , completion: nil)
        }
        
    }
}
