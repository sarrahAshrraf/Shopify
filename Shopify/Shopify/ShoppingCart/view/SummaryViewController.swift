//
//  SummaryViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 17/06/2024.
//

import UIKit
import RxSwift
import RxCocoa
class SummaryViewController: UIViewController {

//    @IBOutlet weak var copounsTF: RoundedTextfield!
//    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var orderCollectionView: UICollectionView!
    @IBOutlet weak var copounTF: UITextField!
    let defaults = UserDefaults.standard
    var currencyRate: Double = 1.0
    var copounUsed = false
    var currencySymbol: String = "USD"
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dicountAMountLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    let disposeBag = DisposeBag()

    var total: Double = 9.0
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        copounTF.text = "\(defaults.value(forKey: Constants.copounValue) ?? " ")"

    }
    func updatePriceLabels(){
        
        orderPriceLabel.text = String(format: "\(currencySymbol) %.2f", total)
               
               if let totalCartPrice = viewModel.result?.total_price, let totalPrice = Double(totalCartPrice) {
                   totalPriceLabel.text = String(format: "\(currencySymbol) %.2f", totalPrice * currencyRate)
               } else {
                   totalPriceLabel.text = String(format: "\(currencySymbol) %.2f", 0.0)
               }
        
    }
    
    func getDiscount() -> Double {
        if let discount = defaults.value(forKey: Constants.copounPercent) as? Double {
            print("copoun getter \(discount)")
            return discount
        }
        print("no copoun percent ")
        return 0.0
    }


    var viewModel = ShoppingCartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        viewModel.getCartItems()
        viewModel.showCartItems()
        bindResultToVC()
        updatePriceLabels()
        getDiscount()

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
    func updatePriceAfterCopoun() {
            let discount = getDiscount()
        print(discount)
            let discountedTotal = total * (discount / 100)
            print("value \(1 - discount / 100)")
        print("total value \(discountedTotal)")
            // Update order price label
//            orderPriceLabel.text = String(format: "\(currencySymbol) %.2f", discountedTotal)
        orderPriceLabel.text = String(format: "\(currencySymbol) %.2f", total)
            // Update total price label
            if let totalCartPrice = viewModel.result?.subtotal_price, let totalPrice = Double(totalCartPrice) {
                totalPriceLabel.text = String(format: "\(currencySymbol) %.2f", (totalPrice * currencyRate) - abs(discountedTotal) )
                print("total privce of vm \(totalPrice)")
                print("discountedTotal \(discountedTotal)")
                print("total  \(total)")
                print("totalPrice * currencyRatet \(totalPrice * currencyRate)")
                print("")
            } else {
                totalPriceLabel.text = String(format: "\(currencySymbol) %.2f", 0.0)
            }
            
        dicountAMountLabel.text = String(format: "\(currencySymbol) %.2f", discountedTotal)
       
        }

    @IBAction func applyCopounBtn(_ sender: Any) {
        let couponCode = copounTF.text ?? ""
        if (couponCode == defaults.value(forKey: Constants.copounValue) as? String){
            copounUsed = true


    }




  
    
    @IBAction func continueToPaymentBtn(_ sender: Any) {

    let storyboard = UIStoryboard(name: "Payment_SB", bundle: nil)
    if let checkOutVC = storyboard.instantiateViewController(withIdentifier: "checkOutVC") as? CheckOutViewController {
        let navController = UINavigationController(rootViewController: checkOutVC)
        checkOutVC.usingCopoun = self.copounUsed
        checkOutVC.copounPercent = self.getDiscount()
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
        let totalWidth = UIScreen.main.bounds.width
        let totalHeight = UIScreen.main.bounds.height
        
        // Calculating available width for cells
        let horizontalInsets: CGFloat = 8 * 2
        let interItemSpacing: CGFloat = 0.0
        let numberOfCellsPerRow: CGFloat = 2
        let availableWidth = totalWidth - horizontalInsets - interItemSpacing * (numberOfCellsPerRow - 1)
        let cellWidth = availableWidth / numberOfCellsPerRow
        
        // Calculating height based on new width for a better aspect ratio
        let verticalInsets: CGFloat = 0
        let lineSpacing: CGFloat = 10
        let availableHeight = totalHeight - verticalInsets - lineSpacing
        let cellHeight = availableHeight
        
        return CGSize(width: cellWidth, height: 167)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

