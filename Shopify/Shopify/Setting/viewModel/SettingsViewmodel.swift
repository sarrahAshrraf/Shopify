//
//  SettingsViewmodel.swift
//  Shopify
//
//  Created by sarrah ashraf on 16/06/2024.
//

import Foundation

class SettingsViewmodel{
    var currencyRates: [String: Double] = [:]

  let defaults = UserDefaults.standard
  var bindCurrencyToViewController: ()->() = {}
    var bindRatesToViewController: ()->() = {}

    
    var rates: Rates? {
        didSet{
            DispatchQueue.main.async {
                self.bindRatesToViewController()
            }
        }
    }

///TODO Change
    func deleteAllFromDB(){
        DatabaseManager.sharedProductDB.deleteAll()
    }

    
    func loadLatestCurrency(currency: String) {
            guard let url = URL(string: URLs.shared.getCurrencyURL()) else { return }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Currency.self, from: data)
                    if let rates = response.rates {
                        self?.currencyRates = rates
                    }
                    if let rate = self?.currencyRates[currency] {
                        print("Rate for \(currency): \(rate)")
                        self?.defaults.setValue(rate, forKey: Constants.CURRENCY_VALUE)
                        self?.defaults.setValue(currency, forKey: Constants.CURRENCY_KEY)
                        

                      
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
            task.resume()
        }
    }



