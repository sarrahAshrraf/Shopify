//
//  LoginViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: RoundedTextfield!
    @IBOutlet weak var passwordTextField: RoundedTextfield!
    var loginViewModel: AuthenticationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = AuthenticationViewModel()
        setupLoginButton()
    }

    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func login(_ sender: UIButton) {
        guard areFieldsValid() else { return }
        
    }
    
    private func areFieldsValid() -> Bool {
        let fields = [emailTextField, passwordTextField]
        let messages = [Constants.emailIsEmpty, Constants.passwordIsEmpty]
        for (index, field) in fields.enumerated() where field?.text?.isEmpty ?? true
        {
            showAlert(title: Constants.warning, message: messages[index])
            return false
        }
        return true
        
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            
        let alert = Alert().showAlertWithPositiveButtons(title: title, msg: message, positiveButtonTitle: Constants.ok, positiveHandler: { _ in completion?() })
        present(alert, animated: true)
    }
    
    private func setupLoginButton() {
        loginButton.tintColor = .white
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
        loginButton.setTitle("LogIn", for: .normal)
    }
}




