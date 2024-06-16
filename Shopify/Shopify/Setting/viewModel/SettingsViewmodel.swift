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

    
    var result: [String: Double]? {
        didSet {
            DispatchQueue.main.async {
                self.bindCurrencyToViewController()
            }
        }
    }

///TODO Change
    func deleteAllFromDB(){
        DatabaseManager.sharedProductDB.deleteAll()
    }
    
    func loadLatestCurrency(currency: String) {
        NetworkManger.shared.getData(url: URLs.shared.getCurrencyURL()) { [weak self] (response: Response?) in
            guard let self = self else { return }

            if let response = response?.currencies?.first {
                self.result = response.rates
                if let rate = response.rates?[currency] {
                    self.defaults.set(currency, forKey: Constants.CURRENCY_KEY)
                    self.defaults.set(rate, forKey: Constants.CURRENCY_VALUE)
                } else {
                    self.handleFailure("Currency rate not found.")
                }
            } else {
                self.handleFailure("Failed to load currency data.")
            }
        }
    }

    private func handleFailure(_ message: String) {
        print("Error: \(message)")
    }
}

