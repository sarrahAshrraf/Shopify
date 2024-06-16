//
//  SettingsViewmodel.swift
//  Shopify
//
//  Created by sarrah ashraf on 16/06/2024.
//

import Foundation

class SettingsViewmodel{

  let defaults = UserDefaults.standard
  var bindCurrencyToViewController: ()->() = {}

    
    var result: [Currency]? = [] {
        didSet{
            DispatchQueue.main.async {
                self.bindCurrencyToViewController()
            }
        }
    }

///TODO Change
    func deleteAllFromDB(){
        DatabaseManager.sharedProductDB.deleteAll()
    }
    
  func loadLatestCurrency(currency: String){
      NetworkManger.shared.getData(url: URLs.shared.getCurrencyURL(), handler: { [weak self] (response : Response?) in
          self?.result = response?.currencies
          self?.defaults.set(currency, forKey: Constants.CURRENCY_KEY)
          self?.defaults.set(self?.result?.first?.rates?[currency], forKey: Constants.CURRENCY_VALUE)
      })
  }
}

