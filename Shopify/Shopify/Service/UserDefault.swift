//
//  UserDefault.swift
//  Shopify
//
//  Created by Ahmed Refat on 20/06/2024.
//

import Foundation

class UserDefault{
    var userDefaults: UserDefaults!
    
    init() {
        userDefaults = UserDefaults.standard
    }
    func getCustomerId() -> Int{
        
        return userDefaults.integer(forKey: Constants.customerId)
    }
    
}
