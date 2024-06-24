//
//  SplashViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 08/06/2024.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    let defaults = UserDefaults.standard

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var splashView: LottieAnimationView!
    @IBOutlet weak var guestButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLottieAnimation()
        setup()
        openAppState()

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
        guestButton.tintColor = .black
        guestButton.layer.borderWidth = 2
        guestButton.layer.borderColor = UIColor.black.cgColor
        guestButton.layer.cornerRadius = guestButton.frame.height / 2
        guestButton.clipsToBounds = true
        guestButton.setTitle("Start Shopping", for: .normal)
        guestButton.addAction(.init(handler: { [weak self] _ in self?.guestButtonTapped() }), for: .touchUpInside)
    }
    
    private func setupSignupButton() {
        signUpButton.tintColor = .white
        signUpButton.backgroundColor = .black
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.clipsToBounds = true
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addAction(.init(handler: { [weak self] _ in self?.signupButtonTapped() }), for: .touchUpInside)
    }
    
    private func guestButtonTapped() {
        defaults.setValue(Constants.USER_STATE_GUEST, forKey:Constants.KEY_USER_STATE )
        defaults.setValue(-1, forKey: Constants.customerId)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "home") 
        home.modalPresentationStyle = .fullScreen
        home.modalTransitionStyle = .crossDissolve
       present(home, animated: true)
        
    }
    
    private func signupButtonTapped() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        home.modalPresentationStyle = .fullScreen
        home.modalTransitionStyle = .crossDissolve
        present(home, animated: true)
    }

    func openAppState(){
        if UserDefault().getAppState() == "Login" {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let home = storyboard.instantiateViewController(identifier: "home")
            home.modalPresentationStyle = .fullScreen
            home.modalTransitionStyle = .crossDissolve
           present(home, animated: true)
        }else {
            print("Guest")
            
        }
    }

}

