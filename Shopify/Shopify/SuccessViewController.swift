//
//  SuccessViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 20/06/2024.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupStartButton()
    }
    
    
    private func setupStartButton() {
        startButton.tintColor = .white
        startButton.backgroundColor = .black
        startButton.layer.cornerRadius = startButton.frame.height / 2
        startButton.clipsToBounds = true
        startButton.setTitle("Start Shopping", for: .normal)
        startButton.addAction(.init(handler: { [weak self] _ in self?.startButtonTapped() }), for: .touchUpInside)
    }
    
    
    private func startButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "home")
        home.modalPresentationStyle = .fullScreen
        home.modalTransitionStyle = .crossDissolve
       present(home, animated: true)
    }


}
