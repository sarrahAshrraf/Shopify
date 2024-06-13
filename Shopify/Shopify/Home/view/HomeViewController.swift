//
//  HomeViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 01/06/2024.
//




import UIKit
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var homeViewModel: HomeViewModel?
    var brandProductViewModel: BrandProductsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.drawTheTopSection()
            default:
                return self.drawTheBottomSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
        fetchBrands()
        homeViewModel?.getItems()
        brandProductViewModel = BrandProductsViewModel()
    }
    
    
    func fetchBrands(){
        homeViewModel = HomeViewModel()
        homeViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    func drawTheTopSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        
        
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let centerX = offset.x + environment.container.contentSize.width / 2.0
            items.forEach { item in
                let distanceFromCenter = abs(item.frame.midX - centerX)
                let scale: CGFloat = distanceFromCenter < 50 ? 1.2 : 1.0
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                
            }
        }
        
        return section
    }

    func drawTheBottomSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.orthogonalScrollingBehavior = .none

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

       return section

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.result?.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = ""
        
        switch indexPath.section {
        case 0:
            cellIdentifier = "adds"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            // Configure the cell for the "adds" section
            return cell
        case 1:
            cellIdentifier = "brands"
            print("cell brand")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BrandsCollectionViewCell
            let results = homeViewModel?.result
            let result = results?[indexPath.row]
            //print(result?.title)
            cell.brandImage.kf.setImage(with: URL(string: result?.image?.src ?? ""))
            //cell.brandName.text = result.title
            return cell
        default:
            fatalError("Unexpected section \(indexPath.section)")
        }
    }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let products = UIStoryboard(name: "BrandProduct", bundle: nil).instantiateViewController(withIdentifier: "BrandProduct") as! BrandViewController
            brandProductViewModel?.brandId = homeViewModel?.result?[indexPath.row].id ?? 0
            
            products.viewModel = brandProductViewModel
            products.modalPresentationStyle = .fullScreen
            present(products, animated: true, completion: nil)
            
        }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       if kind == UICollectionView.elementKindSectionHeader {
           let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CustomHeaderView
           
           switch indexPath.section {
           case 0:
               header.titleLabel.text = "Adds"
           case 1:
               header.titleLabel.text = "Brands"
           default:
               header.titleLabel.text = "Section"
           }
           
           return header
       }
       return UICollectionReusableView()
   }
    
}

class CustomHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}


