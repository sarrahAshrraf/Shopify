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
    var favoritesViewModel: FavoritesViewModel!
    var registered = false
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpViewModel = AuthenticationViewModel()
        favoritesViewModel = FavoritesViewModel()
        setupRegisterButton()
        signUpViewModel.bindUserToController = { [weak self] in
            self?.handleUserSignUp()
        }
        
        favoritesViewModel.bindGetFavoriteDraftOrderToController = {[weak self] in
            self?.getFavouriteDraftOrder()
        }
//    Rnsab1234?
        signUpViewModel.bindUsersListToController = { [weak self] in
            self?.checkUserRegistration()
        }
        
        signUpViewModel.bindDraftOrderToController = {[weak self] in
            self?.handleDraftOrder()
        }
    }
    

        
    
    func checkUserRegistration() {
            if let email = emailTextField.text, signUpViewModel.usersList.contains(where: { $0.email == email }) {
                registered = true
            }
            if registered {
                registered = false
                showAlertWithNegativeAndPositiveButtons(title: Constants.warning, message: Constants.emailUsedBefore)
            } else {
                let user = User(id: nil, firstName: firstNameTextField.text, lastName: lastNameTextField.text, email: emailTextField.text, phone: phoneTextField.text, tags: passwordTextField.text)
                let response = Response(smart_collections: nil, customer: user, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: nil, orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
                let params = encodeToJson(objectClass: response)
                signUpViewModel.postUser(parameters: params ?? [:])
            }
        }
    
     func handleUserSignUp() {
        if(signUpViewModel.user?.id != nil){
            defaults.setValue(self.signUpViewModel.user?.id, forKey: Constants.customerId)
            createDraftOrder(note: "favorite")
            createDraftOrder(note: "cart")
            defaults.setValue(Constants.USER_STATE_LOGIN, forKey:Constants.KEY_USER_STATE )
            defaults.setValue(signUpViewModel.user?.firstName, forKey:Constants.USER_FirstName )
            let alert = Alert().showAlertWithPositiveButtons(title: Constants.congratulations, msg: Constants.registeredSuccessfully, positiveButtonTitle: Constants.ok){_ in
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let home = storyboard.instantiateViewController(identifier: "home") 
                home.modalPresentationStyle = .fullScreen
                home.modalTransitionStyle = .crossDissolve
                self.present(home, animated: true)
            }
            self.present(alert, animated: true)
        } else if signUpViewModel.code == 422 {
            showAlert(title: Constants.warning, message: Constants.phoneUsedbefore)
        }
    }
    
    func getFavouriteDraftOrder(){
        guard let lineItemsList = favoritesViewModel.getFavoriteDraftOrder?.line_items else {return}
        let list = lineItemsList.filter{$0.title != "dummy"}
        for item in list {
                let localProduct = LocalProduct(id: item.productId ?? 0, customer_id: (defaults.integer(forKey: Constants.customerId)), variant_id: item.variantId!, title: item.title!, price: item.price!, image: item.properties![0].value!)
                favoritesViewModel.addProduct(product: localProduct)
        }
        
    }
    
    func handleDraftOrder(){
        if(signUpViewModel.cartDraftOrder?.id != nil && signUpViewModel.favoritesDraftOrder?.id != nil){
            guard let cartId = signUpViewModel.cartDraftOrder?.id else {return}
            guard let favoritesId = signUpViewModel.favoritesDraftOrder?.id else {return}
            defaults.set(cartId, forKey: Constants.cartId)
            defaults.set(favoritesId, forKey: Constants.favoritesId)
            var user = User()
            user.note = "\(favoritesId),\(cartId)"
            let response = Response(smart_collections: nil, customer: user, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: nil, orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
            print("response: \(response)")
            let params = encodeToJson(objectClass: response)
            signUpViewModel.putUser(parameters: params ?? [:])
        }
    }
    
    @IBAction func navigateBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SignUpUser(_ sender: UIButton) {
        validateAndSignUp()
    }
    
    
    func encodeToJson(objectClass: Response) -> [String: Any]?{
        do{
            let jsonData = try JSONEncoder().encode(objectClass)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonToDictionary(from: json)
        }catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func jsonToDictionary(from text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String : Any]
    }
    
    @IBAction func navigateToLogin(_ sender: UIButton) {let login = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        login.modalPresentationStyle = .fullScreen
        present(login, animated: true)
        
        
    }
    func isValidPassword(password: String) -> Bool{
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordRegex.evaluate(with: password)
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
    
    
    func createDraftOrder(note: String){
        let properties = [Properties(name: "image_url", value: "")]
        let lineItems = [LineItems(price: "20.0", quantity: 1, title: "dummy", properties:properties)]

        let user = User(id: defaults.integer(forKey: Constants.customerId), firstName: self.firstNameTextField.text, lastName: self.lastNameTextField.text, email: self.emailTextField.text, phone: self.phoneTextField.text, addresses: nil, tags: self.passwordTextField.text)

        let draft = DraftOrder(id: nil, note: note, line_items: lineItems, customer: user)
        
        let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: draft ,  orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
        let params = self.encodeToJson(objectClass: response)
    
        self.signUpViewModel.postDraftOrder(parameters: params ?? [:])
    }

}





