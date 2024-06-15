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
    var exists = false
    let defaults = UserDefaults.standard
    var customerId: Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = AuthenticationViewModel()
        setupLoginButton()

        loginViewModel.bindUsersListToSignUpController = { [weak self] in
            self?.handleUsersList()
        }
        print(customerId)

    }
    
    private func handleUsersList() {
        guard let list = loginViewModel.usersList else { return }
        for user in list {
            if user.email == emailTextField.text && user.tags == passwordTextField.text {
                exists = true
                customerId = user.id
                defaults.setValue(user.id, forKey: Constants.customerId)
                break
            }
        }
        DispatchQueue.main.async {
            if self.exists {
                self.navigateToHome()
            } else {
                self.showAlert(title: Constants.warning, message: Constants.checkEmailAndPassword)
            }
        }
    }

    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let home = storyboard.instantiateViewController(identifier: "home") as? UINavigationController {
            home.modalPresentationStyle = .fullScreen
            home.modalTransitionStyle = .crossDissolve
            present(home, animated: true)
        }
    }
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func login(_ sender: UIButton) {
        guard areFieldsValid() else { return }
        loginViewModel.getUsers()
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




