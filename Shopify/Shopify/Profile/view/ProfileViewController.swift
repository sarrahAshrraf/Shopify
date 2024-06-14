//
//  ProfileViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 05/06/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func moreOrdersBtn(_ sender: Any) {
    }
    @IBAction func moreFavBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupNavigationBar()
    }
    
//    func setupNavigationBar() {
//        self.title = "Profile"
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
//        self.navigationItem.leftBarButtonItem = backButton
//        
//        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonTapped))
//        
//        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartButtonTapped))
//        
//        self.navigationItem.rightBarButtonItems = [settingsButton, cartButton]
//    }
//    
//    @objc func backButtonTapped() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @objc func settingsButtonTapped() {
////        if let storyboard = UIStoryboard(name: "ProfileStoryboard", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as? SettingsViewController {
////            self.navigationController?.pushViewController(storyboard, animated: true)
////        }
//    }
//    
//    @objc func cartButtonTapped() {
//        
//    }
}
