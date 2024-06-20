//
//  AuthenticationViewModel.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import Foundation
import Alamofire

class AuthenticationViewModel {
    
    var bindUserToController:(()->Void) = {}
    var bindUsersListToController:(()->Void) = {}
    var bindDraftOrderToController:(()->Void) = {}
    var bindUserWithDraftOrderToController:(()->Void) = {}
    
    
    var user: User?{
        didSet{
            bindUserToController()
        }
    }
    var code: Int?
    var usersList: [User]! = []{
        didSet{
            bindUsersListToController()
        }
    }
    
    var favoritesDraftOrder: DraftOrder? {
        didSet {
            bindDraftOrderToController()
        }
    }
    var cartDraftOrder: DraftOrder? {
        didSet {
            bindDraftOrderToController()
        }
    }
    
    var userWithDraftOrder: User?{
        didSet{
            bindUserWithDraftOrderToController()
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
    
    
    func postDraftOrder(parameters: Parameters){
        
        let url = URLs.shared.postDraftOrder()
        NetworkManger.shared.postData(path: url ,parameters: parameters) { [weak self] (response,code) in
        
            if(response?.draft_order?.note == "favorite"){
                self?.favoritesDraftOrder = response?.draft_order
            }
            else if(response?.draft_order?.note == "cart"){
                self?.cartDraftOrder = response?.draft_order
            }
            self?.code = code
        }
    }
    
    func putUser(parameters: Parameters){
        let url = URLs.shared.customerWithDraftOrder()
        NetworkManger.shared.putData(path: url, parameters: parameters, handler: { [weak self] response,code  in
            self?.userWithDraftOrder = response?.customer
        })
    }
    
}
