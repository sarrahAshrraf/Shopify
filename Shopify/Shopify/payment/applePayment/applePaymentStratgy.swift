//
//  applePaymentStratgy.swift
//  Shopify
//
//  Created by sarrah ashraf on 19/06/2024.
//

import Foundation
import PassKit
var currencySymbol: String {
  return UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "EGP"
}
var currencyValue: Double {
  var value = UserDefaults.standard.double(forKey: Constants.CURRENCY_VALUE)
  if value == 0.0 { value = 1.0 }
  return value
}
protocol PaymentStrategy{
  func pay(moneyAmount: Double, viwController: UIViewController) -> (Bool, String)
}
class ApplePaymentStrategy: PaymentStrategy{

  private var paymentRequest: PKPaymentRequest = {
    let request = PKPaymentRequest()
    request.merchantIdentifier = "merchant.com.pushpendra.pay"
    request.supportedNetworks = [.visa, .masterCard, .girocard]
    request.supportedCountries = ["EG", "US"]
    request.merchantCapabilities = .capability3DS
      if currencySymbol == "EUR"{
          print("Can not done")
          request.countryCode = "US"
          currencySymbol == "US"
//          TODO: ALert present
      }else {
          request.countryCode = String(currencySymbol.dropLast(1))
      }
    request.currencyCode = currencySymbol

    return request
  }()

  
  func pay(moneyAmount: Double, viwController: UIViewController) -> (Bool, String) {
    let formattedAmount = Double(String(format: "%.1f", moneyAmount)) ?? 0.0
    paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Shopify Shopping Cart", amount: NSDecimalNumber(value: formattedAmount))]
    let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
    controller?.delegate = (viwController as! any PKPaymentAuthorizationViewControllerDelegate)
      viwController.present(controller!, animated: true)
    return (true, "payment in process...")
  }
}
class CashPaymentStrategy: PaymentStrategy{

  func pay(moneyAmount: Double, viwController: UIViewController) -> (Bool, String) {
    if moneyAmount < 500 * currencyValue {
      return (true, "Done the payment successfully")
    } else {
      return (false, "The total amount is so big, please choose another payment method!")
    }

  }
}
class PaymentContext{
  private var paymentStrategy: PaymentStrategy

  init(pyamentStrategy: PaymentStrategy) {
    self.paymentStrategy = pyamentStrategy
  }

  func setPaymentStrategy(paymentStrategy: PaymentStrategy){
    self.paymentStrategy = paymentStrategy
  }

  func makePayment(moenyAmount: Double, viwController: UIViewController) -> (Bool, String){
    return paymentStrategy.pay(moneyAmount: moenyAmount, viwController: viwController)
  }
}
