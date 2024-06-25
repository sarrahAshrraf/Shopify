//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mohamed Kotb Saied Kotb on 07/06/2024.
//

import Foundation
class HomeViewModel {
    var bindResultToViewController: (()->()) = {}
    var bindDiscountToViewController: (()->()) = {}
    var bindPriceRulesToViewController: (()->()) = {}
    var result: [SmartCollections]? = [] {
        didSet{
            self.bindResultToViewController()
            
        }
    }
    var priceRuleDiscounts: [DiscountCode]? = [] {
        didSet{
            self.bindDiscountToViewController()
            
        }
    }
    
    var priceRules: [PriceRule]? = [] {
        didSet{
            self.bindPriceRulesToViewController()
            
        }
    }
    func getItems(){
        let url = URLs.shared.getBrandsURL()
        NetworkManger.shared.getData(url: url){ [weak self] (response: Response?) in
            self?.result = response?.smart_collections
        }
    }
    
    func getAllDiscountCoupons(priceRule: PriceRule) {
        let url = "https://349c94c1c855b8b029a39104a4ae2e13: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@mad44-alx-ios-team1.myshopify.com/admin/api/2024-04/price_rules/\(priceRule.id)/discount_codes.json"
        NetworkManger.shared.getData(url: url) { [weak self] (response: Response?) in
            self?.priceRuleDiscounts = response?.discount_codes
            print("discountsssss")
            print(response?.discount_codes)
            

        }
    }
      
    
    func getAllPriceRules() {
        let url = URLs.shared.getPriceRule()
        NetworkManger.shared.getData(url: url) { [weak self] (response: Response?) in
            self?.priceRules = response?.price_rules
            print("rulesssss")

            print(response?.price_rules)

        }
    }
    func checkInternetConnectivity()->Bool{
        return ConnectivityManager.connectivityInstance.isConnectedToInternet()
    }
}

