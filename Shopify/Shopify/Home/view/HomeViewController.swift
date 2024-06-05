//
//  HomeViewController.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 01/06/2024.
//

//import UIKit
//
//class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        
//        let layout = UICollectionViewCompositionalLayout{sectionindex,enviroment
//            in switch sectionindex {
//                        case 0 :
//                            return self.drawTheTopSection()
//                        default:
//                            return self.drawTheButtomSection()
//                        }
//        }
//        collectionView.setCollectionViewLayout(layout, animated: true)
//    }
//    
//    
//    func drawTheTopSection ()-> NSCollectionLayoutSection{
//        //6 item size
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        //5 create item
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        // 4 group size
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .absolute(230))
//        //3 create group
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8 )
//        //2 create section
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0)
//        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
//             items.forEach { item in
//             let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
//             let minScale: CGFloat = 0.8
//             let maxScale: CGFloat = 1.2
//             let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
//             item.transform = CGAffineTransform(scaleX: scale, y: scale)
//             }
//        }
//        return section
//    }
//    
//    
//    
//    
//    
//    
//    func drawTheButtomSection()->NSCollectionLayoutSection {
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//            , heightDimension: .fractionalHeight(1))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//            , heightDimension: .absolute(180))
//            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
//            , subitems: [item])
//            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
//            , bottom: 8, trailing: 0)
//            
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
//            , bottom: 10, trailing: 15)
//            
//            return section
//        }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    
//     func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//
//  
//
//    
//     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//           var cellIdentifier = ""
//        
//        switch indexPath.section {
//        case 0 :
//            cellIdentifier = "adds"
//        case 1 :
//            cellIdentifier = "brands"
//        default:
//            print("error")
//        }
//           
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
//         
//           return cell
//        }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}



import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.drawTheTopSection()
            default:
                return self.drawTheBottomSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func drawTheTopSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .absolute(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0)
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.2
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
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
        
        return section
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = ""
        
        switch indexPath.section {
        case 0:
            cellIdentifier = "adds"
        case 1:
            cellIdentifier = "brands"
        default:
            print("error")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    
    
    
}

