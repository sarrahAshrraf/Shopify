//
//  SplashViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 08/06/2024.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var splashView: LottieAnimationView!
    @IBOutlet weak var guestButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLottieAnimation()
        setup()

        // Do any additional setup after loading the view.
    }
    
    
    private func showLottieAnimation() {
        splashView.animation = .named("EcoMarket")
        splashView.loopMode = .loop
        splashView.play()
    }
    
    // MARK: - Setup UI
    private func setup() {
        setupGuestButton()
        setupSignupButton()
    }
    
    private func setupGuestButton() {
        guestButton.backgroundColor = .white
        guestButton.tintColor = UIColor(named: "PrimaryColor")
        guestButton.layer.borderWidth = 2
        if let primaryColor = UIColor(named: "PrimaryColor") {
            guestButton.layer.borderColor = primaryColor.cgColor
        }
        guestButton.layer.cornerRadius = guestButton.frame.height / 7
        guestButton.clipsToBounds = true
        guestButton.setTitle("Start Shopping", for: .normal)
        guestButton.addAction(.init(handler: { [weak self] _ in self?.guestButtonTapped() }), for: .touchUpInside)
    }
    
    private func setupSignupButton() {
        signUpButton.tintColor = .white
        signUpButton.backgroundColor = UIColor(named: "PrimaryColor")
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 7
        signUpButton.clipsToBounds = true
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addAction(.init(handler: { [weak self] _ in self?.signupButtonTapped() }), for: .touchUpInside)
    }
    
    private func guestButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "home") as! UINavigationController
        home.modalPresentationStyle = .fullScreen
        home.modalTransitionStyle = .crossDissolve
       present(home, animated: true)
        
    }
    
    private func signupButtonTapped() {
    }

    

}
