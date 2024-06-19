//
//  cashPayment.swift
//  Shopify
//
//  Created by sarrah ashraf on 19/06/2024.
//
var currencyValue: Double {
  var value = UserDefaults.standard.double(forKey: Constants.CURRENCY_VALUE)
//  print("liwurhgiuohlitg1111")
//  print(value)
  if value == 0.0 { value = 1.0 }
  return value
}
import Foundation
import PassKit
class CashPaymentStrategy: PaymentStrategy{

  func pay(amount: Double, vc: UIViewController) -> (Bool, String) {
    if amount < 500 * currencyValue {
      return (true, "Purchased successfully")
    } else {
      return (false, "The total amount is so big, please choose another payment method!")
    }

  }
}
