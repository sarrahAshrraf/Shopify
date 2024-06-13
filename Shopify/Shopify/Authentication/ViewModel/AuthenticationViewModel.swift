//
//  AuthenticationViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import Foundation
import Alamofire

class AuthenticationViewModel {
    
    var bindUserToSignUpController:(()->Void) = {}
    var bindUsersListToSignUpController:(()->Void) = {}
    
    
    var user: User?{
        didSet{
            bindUserToSignUpController()
        }
    }
    var code: Int?
    var usersList: [User]! = []{
        didSet{
            bindUsersListToSignUpController()
        }
    }
    
    
    func postUser(parameters: Parameters){
        print(parameters)
        let url = URLs.shared.customersURL()
        NetworkManger.shared.postData(path: url, parameters: parameters){ [weak self] (response,code) in
            self?.user = response?.customer
            self?.code = code
            }
    }
    
    func getUsers(){
        let url = URLs.shared.customersURL()
        NetworkManger.shared.getData(url: url, handler: { [weak self] response in
            self?.usersList = response?.customers
        })
    }
    
}
