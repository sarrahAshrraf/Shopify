//
//  SignUpViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var firstNameTextField: RoundedTextfield!
    @IBOutlet weak var lastNameTextField: RoundedTextfield!
    @IBOutlet weak var phoneTextField: RoundedTextfield!
    @IBOutlet weak var emailTextField: RoundedTextfield!
    @IBOutlet weak var passwordTextField: RoundedTextfield!
    @IBOutlet weak var confirmPasswordTextField: RoundedTextfield!
    var signUpViewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpViewModel = AuthenticationViewModel()
        setupRegisterButton()
        
    }
    

        
    
    
    
    @IBAction func navigateBack(_ sender: UIButton) {
    
    }
    
    @IBAction func SignUpUser(_ sender: UIButton) {
        validateAndSignUp()
    }
    
    
 
    
    @IBAction func navigateToLogin(_ sender: UIButton) {
        
    }
    

    private func validateAndSignUp() {
        guard areFieldsValid() else { return }
        if !isValidPassword(password: passwordTextField.text ?? "") {
            showAlert(title: Constants.warning, message: Constants.invalidPassword) {
                self.passwordTextField.setText("")
                self.confirmPasswordTextField.setText("")
            }
        } else if passwordTextField.text != confirmPasswordTextField.text {
            showAlert(title: Constants.warning, message:
                        Constants.passwordAndConfirmPasswordShouldBeTheSame) {
                self.passwordTextField.setText("")
                self.confirmPasswordTextField.setText("")
            }
        } else {
                signUpViewModel.getUsers()
        }
    }
    
    func isValidPassword(password: String) -> Bool{
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordRegex.evaluate(with: password)
    }

    private func areFieldsValid() -> Bool {
        let fields = [firstNameTextField, lastNameTextField, phoneTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        let messages = [Constants.firstNameIsEmpty, Constants.lastNameIsEmpty, Constants.phoneIsEmpty, Constants.emailIsEmpty, Constants.passwordIsEmpty, Constants.confirmPasswordIsEmpty]
        
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

        
    private func showAlertWithNegativeAndPositiveButtons(title: String, message: String) {
            
        let alert = Alert().showAlertWithNegativeAndPositiveButtons(title: title, msg: message, negativeButtonTitle: Constants.cancel, positiveButtonTitle: Constants.ok, negativeHandler: nil) { _ in }
        present(alert, animated: true)
    }
    
    private func setupRegisterButton() {
        registerBtn.tintColor = .white
        registerBtn.backgroundColor = .black
        registerBtn.layer.cornerRadius = registerBtn.frame.height / 2
        registerBtn.clipsToBounds = true
        registerBtn.setTitle("Sign Up", for: .normal)
    }

}





