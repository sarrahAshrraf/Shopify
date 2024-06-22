//
//  HomeViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 01/06/2024.
//




import UIKit
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var couponsCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var searchBar: RoundedTextfield!
    var timer:Timer?
    var currentCellIndex=0
    
    var staticCoupons : [String] = ["coupon1.png","coupon2.png", "coupon3.jpeg"]
    
    var homeViewModel: HomeViewModel?
    var favoritesViewModel: FavoritesViewModel!
    var brandProductViewModel: BrandProductsViewModel?
    var defaults = UserDefaults.standard
    var lineItems:[LineItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.brandsCollectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCell")
        self.couponsCollectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCell")
        fetchBrands()
        homeViewModel?.getItems()
        brandProductViewModel = BrandProductsViewModel()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
        self.pageController.numberOfPages = staticCoupons.count
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToSearch(_:)))
        searchBar.addGestureRecognizer(tapGestureRecognizer)
        searchBar.isUserInteractionEnabled = true
        
        favoritesViewModel = FavoritesViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        putFavouriteListToAPI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    @objc func navigateToSearch() {
        let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
        let searchVC = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.modalTransitionStyle = .crossDissolve
        present(searchVC, animated: true, completion: nil)
    }
    @objc func moveToNextIndex(){
        if currentCellIndex < staticCoupons.count - 1 {
            currentCellIndex += 1
        }else {
            currentCellIndex = 0
        }
        self.couponsCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        self.pageController.currentPage = currentCellIndex
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
    
    @IBAction func navigateToSearch(_ sender: Any) {
        
        
        let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
        let searchVC = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.modalTransitionStyle = .crossDissolve
        present(searchVC, animated: true , completion: nil)
    }
    func fetchBrands(){
        homeViewModel = HomeViewModel()
        homeViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.brandsCollectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == couponsCollectionView {
            return staticCoupons.count
        }else {
            
            return homeViewModel?.result?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == couponsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath)as! HomeViewCell
            cell.homeImage.image = UIImage(named: staticCoupons[indexPath.row])
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeViewCell
            let results = homeViewModel?.result
            let result = results?[indexPath.row]
            //print(result?.title)
            cell.homeImage.kf.setImage(with: URL(string: result?.image?.src ?? ""))
            cell.contentView.layer.borderWidth = 1.5
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.cornerRadius = 12
            return cell
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView {
            return CGSize(width: (collectionView.bounds.width*1.0), height: (collectionView.bounds.height*1.0))
        }else {
            return CGSize(width: (collectionView.bounds.width*0.5), height: (collectionView.bounds.height*1.0))
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  20
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == couponsCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == couponsCollectionView {
            
        }else {
            let products = UIStoryboard(name: "BrandProduct", bundle: nil).instantiateViewController(withIdentifier: "BrandProduct") as! BrandViewController
            brandProductViewModel?.brandId = homeViewModel?.result?[indexPath.row].id ?? 0
            
            products.viewModel = brandProductViewModel
            products.modalPresentationStyle = .fullScreen
            present(products, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView == brandsCollectionView){
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }
    }
    
    
    

    
    
    func putFavouriteListToAPI() {
      
        self.favoritesViewModel.getAllProducts()
        favoritesViewModel.bindallProductsListToController = {[weak self] in
            guard let self = self else { return }
            
            
            // Clear lineItems to avoid duplicate entries from previous calls
            self.lineItems.removeAll()
            
            for product in FavouriteViewController.staticFavoriteList {
                if self.defaults.integer(forKey: Constants.customerId) == product.customer_id {
                    // Check if the product already exists in lineItems
                    if !self.lineItems.contains(where: { $0.productId == product.id }) {
                        self.lineItems.append(LineItems(price: product.price, productId: product.id, quantity: 1, title: product.title, variantId: product.variant_id, properties: [Properties(name: "image_url", value: product.image)]))
                    }
                }
            }
            
            
            if !self.lineItems.isEmpty {
                var user = User()
                user.id = self.defaults.integer(forKey: Constants.customerId)
                
                let draft = DraftOrder(id: nil, note: nil, line_items: self.lineItems, customer: user)
                let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: draft, orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
                
                let params = JSONCoding().encodeToJson(objectClass: response)!
                
                self.favoritesViewModel.putFavoriteDraftOrderFromAPI(parameters: params)
            }else {
                let properties = [Properties(name: "image_url", value: "")]
                
                let lineItems = [LineItems(price: "100.0", quantity: 1, title: "dummy", properties: properties)]
                
                var user = User()
                user.id = self.defaults.integer(forKey: Constants.customerId)
                let draft = DraftOrder(id: nil, note: nil, line_items: self.lineItems, customer: user)
                let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: draft, orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
                
                let params = JSONCoding().encodeToJson(objectClass: response)!
                self.favoritesViewModel.putFavoriteDraftOrderFromAPI(parameters: params)
                
            }
            
        }
        
    }
    
    
}

    


    

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return homeViewModel?.result?.count ?? 0
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cellIdentifier = ""
//        
//        switch indexPath.section {
//        case 0:
//            cellIdentifier = "adds"
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
//            // Configure the cell for the "adds" section
//            return cell
//        case 1:
//            cellIdentifier = "brands"
//            print("cell brand")
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BrandsCollectionViewCell
//            let results = homeViewModel?.result
//            let result = results?[indexPath.row]
//            //print(result?.title)
//            cell.brandImage.kf.setImage(with: URL(string: result?.image?.src ?? ""))
//            //cell.brandName.text = result.title
//            return cell
//        default:
//            fatalError("Unexpected section \(indexPath.section)")
//        }
//    }
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let products = UIStoryboard(name: "BrandProduct", bundle: nil).instantiateViewController(withIdentifier: "BrandProduct") as! BrandViewController
//            brandProductViewModel?.brandId = homeViewModel?.result?[indexPath.row].id ?? 0
//            
//            products.viewModel = brandProductViewModel
//            products.modalPresentationStyle = .fullScreen
//            present(products, animated: true, completion: nil)
//            
//        }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//       if kind == UICollectionView.elementKindSectionHeader {
//           let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CustomHeaderView
//           
//           switch indexPath.section {
//           case 0:
//               header.titleLabel.text = "Adds"
//           case 1:
//               header.titleLabel.text = "Brands"
//           default:
//               header.titleLabel.text = "Section"
//           }
//           
//           return header
//       }
//       return UICollectionReusableView()
//   }
//    
//}
//
//class CustomHeaderView: UICollectionReusableView {
//    let titleLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//
//    private func setupViews() {
//        addSubview(titleLabel)
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
//        ])
//    }
//    
//}
//
//
