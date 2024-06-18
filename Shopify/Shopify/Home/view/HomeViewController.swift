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
    
    var timer:Timer?
    var currentCellIndex=0
    
    var staticCoupons : [String] = ["coupon1.png","coupon2.png", "coupon3.jpeg"]
    
    var homeViewModel: HomeViewModel?
    var brandProductViewModel: BrandProductsViewModel?

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
            
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
        
        let storyboard = UIStoryboard(name: "FavouriteStoryboard", bundle: nil)
        let favoriteVC = storyboard.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
        
        favoriteVC.modalPresentationStyle = .fullScreen
        favoriteVC.modalTransitionStyle = .crossDissolve
        present(favoriteVC, animated: true , completion: nil)
        
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
