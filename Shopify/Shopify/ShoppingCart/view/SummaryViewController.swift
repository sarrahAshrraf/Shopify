//
//  SummaryViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 17/06/2024.
//

import UIKit

class SummaryViewController: UIViewController {

    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var orderCollectionView: UICollectionView!
    @IBOutlet weak var copounTF: UITextField!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var currencySymbol: String = "USD"
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dicountAMountLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    var total: Double = 9.0
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        updatePriceLabels()
      
    }
    var viewModel = ShoppingCartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        viewModel.getCartItems()
        viewModel.showCartItems()
        bindResultToVC()
        updatePriceLabels()
//        orderPriceLabel.text = String(format: "\(currencySymbol) %.2f", total)

    }

    func setupNavigationBar() {
        self.title = "Order Summary"
        if let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    func bindResultToVC() {
        viewModel.bindResultToViewController = { [weak self] in
            self?.setCurrencyValues()
            self?.orderCollectionView.reloadData()
            self?.updatePriceLabels()
        }
    }
    
    func setCurrencyValues() {
        if let rate = defaults.value(forKey: Constants.CURRENCY_VALUE) as? Double {
            currencyRate = rate
        }
        if let symbol = defaults.string(forKey: Constants.CURRENCY_KEY) {
            currencySymbol = symbol
        }
    }
    
    func updatePriceLabels() {
        orderPriceLabel.text = String(format: "\(currencySymbol) %.2f", total)
        
        if let totalCartPrice = viewModel.result?.total_price, let totalPrice = Double(totalCartPrice) {
            totalPriceLabel.text = String(format: "\(currencySymbol) %.2f", totalPrice * currencyRate)
        } else {
            totalPriceLabel.text = String(format: "\(currencySymbol) %.2f", 0.0)
        }
        if let totalTax = viewModel.result?.total_tax, let totalTaxes = Double(totalTax) {
            self.taxesLabel.text = String(format: "\(currencySymbol) %.2f", totalTaxes * currencyRate)
        } else {
            taxesLabel.text = String(format: "\(currencySymbol) %.2f", 0.0)
        }
    }

    @IBAction func applyCopounBtn(_ sender: Any) {
    }
    
    @IBAction func continueToPaymentBtn(_ sender: Any) {

    let storyboard = UIStoryboard(name: "Payment_SB", bundle: nil)
    if let checkOutVC = storyboard.instantiateViewController(withIdentifier: "checkOutVC") as? CheckOutViewController {
        let navController = UINavigationController(rootViewController: checkOutVC)
        checkOutVC.total = self.total
                   navController.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(checkOutVC, animated: true)
        self.present(navController, animated: true, completion: nil)
    }

    }
}

extension SummaryViewController: UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartList.cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCollectionViewCell", for: indexPath) as! SummaryCollectionViewCell
        cell.configure(cartItem: CartList.cartItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2.5 - 10, height: UIScreen.main.bounds.height/4 - 12)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
