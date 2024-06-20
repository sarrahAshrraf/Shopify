//
//  GuestViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 20/06/2024.
//

import UIKit

class GuestViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupGuestButton()
        setupSigninButton()
    }
    
    private func setupGuestButton() {
        guestButton.backgroundColor = .white
        guestButton.tintColor = .black
        guestButton.layer.borderWidth = 2
        guestButton.layer.borderColor = UIColor.black.cgColor
        guestButton.layer.cornerRadius = guestButton.frame.height / 2
        guestButton.clipsToBounds = true
        guestButton.setTitle("Continue as Guest", for: .normal)
        guestButton.addAction(.init(handler: { [weak self] _ in self?.guestButtonTapped() }), for: .touchUpInside)
    }
    
    private func setupSigninButton() {
        signinButton.tintColor = .white
        signinButton.backgroundColor = .black
        signinButton.layer.cornerRadius = signinButton.frame.height / 2
        signinButton.clipsToBounds = true
        signinButton.setTitle("Sign In", for: .normal)
        signinButton.addAction(.init(handler: { [weak self] _ in self?.signupButtonTapped() }), for: .touchUpInside)
    }
    
    private func guestButtonTapped() {
        self.dismiss(animated: true)
        
    }
    
    private func signupButtonTapped() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true)
    }

}
