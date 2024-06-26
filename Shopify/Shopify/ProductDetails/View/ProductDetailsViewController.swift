//
//  ProductDetailsViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 06/06/2024.
//

import UIKit
import Kingfisher
import JGProgressHUD


class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ImagesCollectionView: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productSizeCollectionView: UICollectionView!
    @IBOutlet weak var productColorCollectionView: UICollectionView!
    @IBOutlet weak var productReviewTableView: UITableView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productStockCount: UILabel!
    @IBOutlet weak var steperCount: UILabel!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var bottomConstriant: NSLayoutConstraint!
    @IBOutlet weak var favoriteBtnOutlet: UIButton!
    @IBOutlet weak var minusBtnOutlet: UIButton!
    @IBOutlet weak var addBtnOutlet: UIButton!
        
    var sizeCollectionHandler = SizeCollectionDelegatesHandling()
    var colorCollectionHandler = ColorCollectionDelegatesHandling()
    var reviewTableHandler = ReviewsDelegatesHandling()
    
    var viewModel: ProductDetailsViewModel!
    var customerID = 7309504250029
    var shoppingCartViewModel: ShoppingCartViewModel!
    var favoritesViewModel: FavoritesViewModel!
    var orderCount = 1
    var defaults: UserDefaults = UserDefaults.standard
    var productInCart = false
    var product:Product!
    var imagesArray : [String] = []
    var currentIndex = 0
    var timer:Timer?
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    
    
    var selectedSize: String!{
        didSet{
            var colorArray:[String] = []
            for variant in product.variants! {
                if variant.option1 == selectedSize{
                    colorArray.append(variant.option2!)
                }
            }
            colorCollectionHandler.colorArr = colorArray
            productColorCollectionView.reloadData()
            if selectedSize != nil{
                productPriceLabel.text = "Select color"
                productStockCount.text = "Select color"
            }
            selectedColor = nil
            minusBtnOutlet.isEnabled = false
            addToCartView.isHidden = true
            steperCount.text = "1"
            bottomConstriant.constant = 16
        }
    }
    var selectedColor: String!{
        didSet{
            checkPriceAndAvailability()
            if selectedSize != nil && selectedColor != nil {
                addToCartView.isHidden = false
                bottomConstriant.constant = 85
                
            }
        }
    }
                
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingCartViewModel = ShoppingCartViewModel()
        favoritesViewModel = FavoritesViewModel()
        fetchData()
        showData()
        setUpProductImagesArr()
        setUpSizeCollectionCell()
        setUpColorCollectionCell()
        setUpReviewTableCell()
        setUpCollectionCells()
        playTimer()
        setCurrency()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addToCartView.isHidden = true
        bottomConstriant.constant = 16
        steperCount.text = "1"
        selectedSize = nil
        selectedColor = nil
        colorCollectionHandler.colorArr = product.options?[1].values ?? []
        resetUI()
        setupUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        productColorCollectionView.reloadData()
        productSizeCollectionView.reloadData()
        productReviewTableView.reloadData()
        ImagesCollectionView.reloadData()
    }
    
    
    
    func setCurrency(){
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) ?? "USD"
            currencySymbol = symbol
    }
    
    
    func setUpCollectionCells(){
        ImagesCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        
        productSizeCollectionView.register(UINib(nibName: "VariantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VariantCollectionViewCell")
        
        productColorCollectionView.register(UINib(nibName: "VariantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VariantCollectionViewCell")
        
        productReviewTableView.register(UINib(nibName:"ProductReviewCell" , bundle: nil), forCellReuseIdentifier: "ProductReviewCell")
        
    }
    func setupUI(){
        checkFavorite()
        //showFavoriteBtn()
    }
    
    func fetchData(){
        viewModel.getItems()
    }
    
    func showData(){
      viewModel.bindResultToViewController = { [weak self] in

        DispatchQueue.main.async {
            self?.productName.text = self?.viewModel.result?.title
            self?.productDescriptionLabel.text = self?.viewModel.result?.bodyHtml
            self?.productBrand.text = (self?.viewModel.result?.vendor ?? "") + "," + (self?.viewModel.result?.productType ?? "")
            
        }
      }
        print("customerID")
        print(defaults.integer(forKey: Constants.customerId))
    }
    
    func showFavoriteBtn(){
        if UserDefault().getCustomerId() == -1 {
            favoriteBtnOutlet.isHidden = true
        }else {
            favoriteBtnOutlet.isHidden = false
        }
    }
    
    
    
    func checkFavorite(){
        let isFav = favoritesViewModel.checkIfProductIsFavorite(productId: product.id, customerId: defaults.integer(forKey: Constants.customerId))
        if isFav {
            self.favoriteBtnOutlet.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
        } else {
            self.favoriteBtnOutlet.setImage(UIImage(systemName: Constants.heart), for: .normal)
        }
    }
    func setUpProductImagesArr(){
        for image in product.images!{
            imagesArray.append(image.src!)
        }
        self.pageControl.numberOfPages = imagesArray.count
    }

    func setUpSizeCollectionCell(){
        sizeCollectionHandler.viewController = self
        productSizeCollectionView.dataSource = sizeCollectionHandler
        productSizeCollectionView.delegate = sizeCollectionHandler
        sizeCollectionHandler.sizeArr = product.options?[0].values ?? []
    }
    
    func setUpColorCollectionCell(){
        colorCollectionHandler.viewController = self
        productColorCollectionView.dataSource = colorCollectionHandler
        productColorCollectionView.delegate = colorCollectionHandler
        colorCollectionHandler.colorArr = product.options?[1].values ?? []
    }
    
    
    func setUpReviewTableCell(){
        reviewTableHandler.viewController = self
        productReviewTableView.dataSource = reviewTableHandler
        productReviewTableView.delegate = reviewTableHandler
        for i in 0 ..< 3{
            reviewTableHandler.productReviews.append(ProductDetailsViewModel.Reviews[i])
        }
    }
    
    
    func checkPriceAndAvailability(){
        if selectedSize == nil || selectedColor == nil {}
        else{
            for variant in product.variants!{
                let variantName = "\(selectedSize!) / \(selectedColor!)"
                if variant.title! == variantName{
                    if let price = Double(variant.price) {
                        let convertedPrice = price * currencyRate
                        productPriceLabel.text = String(format: "%.0f %@", convertedPrice, currencySymbol)
                    }
                    if variant.inventoryQuantity == nil || variant.inventoryQuantity == 0 {
                        productStockCount.text = "Out of Stock"
                    }else{
                        productStockCount.text = "\(variant.inventoryQuantity!) In Stock"
                    }
                }
            }
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func addToCart(_ sender: Any) {
        if UserDefault().getCustomerId() == -1 {
            Utilities.navigateToGuestScreen(viewController: self)
        }else {
            orderCount = Int(steperCount.text!)!
            let variantName = "\(selectedSize!) / \(selectedColor!)"
            var variantId = 0
            for variant in viewModel.result?.variants ?? [] {
                if variant.title ?? "" == variantName {
                    variantId = variant.id!
                }
            }
            let variantCartStatus = checkVariantIsInCart(variantId: variantId)
            if variantCartStatus.0 {
                if canUpdateCartAmount(variantIndex: variantCartStatus.1) {
                    updateCartAmountAndResetCounter(variantIndex: variantCartStatus.1)
                    
                    
                }else {
                    presentAmountErrorAlert(variantIndex: variantCartStatus.1)
                }
            }else{
                addVariantToOrders(variantName: variantName)
                self.showProgress(message: "Added To Cart")
            }
        }
    }
    
    @IBAction func minusButton(_ sender: Any) {
        let count = Int(steperCount.text ?? "1")! - 1
        steperCount.text = String(count)
        if count != 1 {
            minusBtnOutlet.isEnabled = true
        }
    }
    

    @IBAction func addButton(_ sender: Any) {
        let count = Int(steperCount.text ?? "1")
        steperCount.text = String((count ?? 1) + 1)
        minusBtnOutlet.isEnabled = true
    }
    
    func addVariantToOrders(variantName: String){
        for variant in viewModel.result?.variants ?? [] {
            if variant.title == variantName {
                if variant.inventoryQuantity! > 3 && orderCount <= variant.inventoryQuantity!/3 || variant.inventoryQuantity! <= 3 && orderCount <= variant.inventoryQuantity! {
                    let lineItem = LineItems(name: viewModel.result?.title,price: variant.price, productId: viewModel.result?.id , quantity: orderCount, variantId: variant.id, variantTitle: variantName ,vendor: viewModel.result?.vendor, properties: [Properties(name: String(variant.inventoryQuantity!), value: "\((viewModel.result?.image?.src)!)$\(variant.inventoryItemId!)")])
                    CartList.cartItems.append(lineItem)
                    shoppingCartViewModel.result?.line_items?.append(lineItem)
                    shoppingCartViewModel.editCart()
                    orderCount = 1
                    
                }else{
                    print("you can not")
                    let alert = UIAlertController(title: "Warning", message: "You can not order more than \(variant.inventoryQuantity!/3).", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(alert, animated: true, completion: nil)

                }
            }
        }
    }
    
    func checkVariantIsInCart(variantId: Int) -> (Bool, Int){
        for (index, item) in CartList.cartItems.enumerated(){
            if item.variantId == variantId {
                return (true , index)
            }
        }
        return (false , -1)
    }
    
    
    func canUpdateCartAmount(variantIndex: Int) -> Bool{
        let currentAmountInCart = CartList.cartItems[variantIndex].quantity!
        let totalAmountInStock = Int(CartList.cartItems[variantIndex].properties?[0].name ?? "1") ?? 1
        if (totalAmountInStock > 3 && currentAmountInCart + orderCount <= totalAmountInStock/3) || (totalAmountInStock <= 3 && currentAmountInCart + orderCount <= totalAmountInStock){
            return true
        }else {
            return false
        }
    }
    
    func updateCartAmountAndResetCounter(variantIndex: Int){
        CartList.cartItems[variantIndex].quantity! += orderCount
        shoppingCartViewModel.result?.line_items?[variantIndex].quantity! += orderCount
        orderCount = 1
        shoppingCartViewModel.editCart()
    }
    
    func presentAmountErrorAlert(variantIndex: Int){
        let currentAmountInCart = CartList.cartItems[variantIndex].quantity!
        let totalAmountInStock = Int(CartList.cartItems[variantIndex].properties?[0].name ?? "1") ?? 1
        var cartCount = 0
        if totalAmountInStock <= 3{
            cartCount = totalAmountInStock
        }else{
            cartCount = totalAmountInStock / 3
        }
        print("you can not order more")
        let alert = UIAlertController(title: "Warning", message: "You can not order more than \(cartCount).", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)

    }
    
    func resetUI(){
        addToCartView.isHidden = true
        selectedSize = nil
        selectedColor = nil
        colorCollectionHandler.colorArr = product.options?[1].values ?? []
        productSizeCollectionView.reloadData()
        productPriceLabel.text = "Select Size"
        productStockCount.text = "Select Size"
    }
    
    
    func showProgress(message : String){
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = message
        hud.square = true
        hud.style = .dark
        hud.show(in: view)
        hud.dismiss(afterDelay: 1, animated: true){
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func favouriteButton(_ sender: UIButton) {
        if UserDefault().getCustomerId() == -1 {
            Utilities.navigateToGuestScreen(viewController: self)
        }else {
            if favoriteBtnOutlet.currentImage == UIImage(systemName: Constants.heart) {
                let localProduct = LocalProduct(id: product.id, customer_id: defaults.integer(forKey: Constants.customerId), variant_id: product.variants?[0].id ?? 0, title: product.title ?? "", price: product.variants?[0].price ?? "", image: product.image?.src ?? "")
                favoritesViewModel.addProduct(product: localProduct)
                self.favoritesViewModel.getAllProducts()
                favoriteBtnOutlet.setImage(UIImage(systemName: Constants.fillHeart), for: .normal)
                
                self.showProgress(message: "Added To Favourite")
                
            } else {
                let alert = Alert().showRemoveProductFromFavoritesAlert(title: Constants.removeAlertTitle, msg: Constants.removeAlertMessage) { [weak self] action in
                    self?.favoritesViewModel.removeProduct(id : self!.product.id)
                    self?.favoritesViewModel.getAllProducts()
                    self?.favoriteBtnOutlet.setImage(UIImage(systemName: Constants.heart), for: .normal)
                    self?.showProgress(message: "Deleted")
                }
                present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func navigateToAllReviews(_ sender: UIButton) {
        let reviewsVC = self.storyboard?.instantiateViewController(identifier: "ReviewViewController") as! ReviewViewController
        reviewsVC.modalPresentationStyle = .fullScreen
        reviewsVC.reviewsList = ProductDetailsViewModel.Reviews
        self.present(reviewsVC, animated: true)
    }
    @objc func getCurrentIndex(){
        if currentIndex != imagesArray.count-1 {
            currentIndex += 1
        }else{
            currentIndex = 0
        }
        pageControl.currentPage = currentIndex
        ImagesCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    func playTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.getCurrentIndex), userInfo: nil, repeats: true)
    }
    
}


extension ProductDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
        cell.productImage.kf.setImage(with: URL(string: imagesArray[indexPath.row]),
                                      placeholder: UIImage(named: Constants.noImage))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ImagesCollectionView.frame.width, height: ImagesCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    
}




