//
//  LoginViewController.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: RoundedTextfield!
    @IBOutlet weak var passwordTextField: RoundedTextfield!
    var loginViewModel: AuthenticationViewModel!
    var favoriteViewModel : FavoritesViewModel!
    var exists = false
    let defaults = UserDefaults.standard
    var customerId: Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = AuthenticationViewModel()
        favoriteViewModel = FavoritesViewModel()
        setupLoginButton()
        bindData()
    }
    
    
    func bindData(){
        loginViewModel.bindUsersListToController = { [weak self] in
            self?.handleUsersList()
        }
        
        loginViewModel.bindDraftOrderToController = {[weak self] in
            self?.handleDraftOrder()
        }
        
        loginViewModel.bindUserToController = { [weak self] in
            self?.handleUserSignIn()
            
        }
        
        favoriteViewModel.bindGetFavoriteDraftOrderToController = {[weak self] in
            self?.getFavouriteDraftOrder()
        }
    }
    
    func handleUserSignIn() {
        if(loginViewModel.user?.id != nil){
            defaults.setValue(loginViewModel.user?.id, forKey: Constants.customerId)
            createDraftOrder(note: "favorite")
            createDraftOrder(note: "cart")
        }
    }
    
    func handleDraftOrder(){
        if(loginViewModel.cartDraftOrder?.id != nil && loginViewModel.favoritesDraftOrder?.id != nil){
            guard let cartId = loginViewModel.cartDraftOrder?.id else {return}
            guard let favoritesId = loginViewModel.favoritesDraftOrder?.id else {return}
            defaults.set(cartId, forKey: Constants.cartId)
            defaults.set(favoritesId, forKey: Constants.favoritesId)
            var user = User()
            user.note = "\(favoritesId),\(cartId)"
            let response = Response(smart_collections: nil, customer: user, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: nil, orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
            let params = JSONCoding().encodeToJson(objectClass: response)
            loginViewModel.putUser(parameters: params ?? [:])
        }
    }
    func getFavouriteDraftOrder(){
        guard let lineItemsList = favoriteViewModel.getFavoriteDraftOrder?.line_items else {return}
        let list = lineItemsList.filter{$0.title != "dummy"}
        for item in list {
                
            let localProduct = LocalProduct(id: item.productId ?? 0, customer_id: (defaults.integer(forKey: Constants.customerId)), variant_id: item.variantId!, title: item.title!, price: item.price!, image: item.properties![0].value!)
            favoriteViewModel.addProduct(product: localProduct)
        }
        
    }
    
    private func handleUsersList() {
        guard let list = loginViewModel.usersList else { return }
        for user in list {
            if user.email == emailTextField.text && user.tags == passwordTextField.text {
                exists = true
                customerId = user.id
                defaults.setValue(user.id, forKey: Constants.customerId)
                let noteSpliter = user.note?.components(separatedBy: ",")
                defaults.set(Int((noteSpliter?[1])!), forKey: Constants.cartId)
                defaults.set(Int((noteSpliter?[0])!), forKey: Constants.favoritesId)
                getFavoritesfromAPI()

                defaults.setValue(Constants.USER_STATE_LOGIN, forKey:Constants.KEY_USER_STATE )
                defaults.setValue(user.firstName, forKey:Constants.USER_FirstName )
                defaults.setValue(user.email, forKey:Constants.USER_Email)
                break
            }
        }
        DispatchQueue.main.async {
            if self.exists {
                
                self.loginToFireBase(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
                //Utilities.navigateToSuccesstScreen(viewController: self)
            } else {
                self.showAlert(title: Constants.warning, message: Constants.checkEmailAndPassword)
            }
        }
    }

    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "home")
            home.modalPresentationStyle = .fullScreen
            home.modalTransitionStyle = .crossDissolve
            present(home, animated: true)
        
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
    
    func getFavoritesfromAPI(){
        self.favoriteViewModel.removeAllProduct()
        self.favoriteViewModel.getFavoriteDraftOrderFromAPI()
    }
    
    
    func createDraftOrder(note: String){
        let properties = [Properties(name: "image_url", value: "")]
        let lineItems = [LineItems(price: "20.0", quantity: 1, title: "dummy", properties:properties)]

        var user = User()
        user.id = defaults.integer(forKey: Constants.customerId)
        user.email = self.emailTextField.text
        user.tags = self.passwordTextField.text

        let draft = DraftOrder(id: nil, note: note, line_items: lineItems, customer: user)
        let response = Response(smart_collections: nil, customer: nil, customers: nil, addresses: nil, customer_address: nil, products: nil, product: nil, draft_order: draft ,  orders: nil, order: nil, currencies: nil, base: nil, rates: nil)
        let params = JSONCoding().encodeToJson(objectClass: response)
    
        self.loginViewModel.postDraftOrder(parameters: params ?? [:])
    }
}

extension LoginViewController{
    func loginToFireBase(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion:{[weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            guard error == nil else{
                
                
                return
            }
            strongSelf.checkVerification()

        })
    }
    
    func checkVerification(){
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                // User's email is verified, allow them to enter the app
                Utilities.navigateToSuccesstScreen(viewController: self)
                print("User's email is verified")
            } else {
                // User's email is not verified, show an error message
                print("User's email is not verified")
            }
        }
    }
    

}



