//
//  applePaymentStratgy.swift
//  Shopify
//
//  Created by sarrah ashraf on 19/06/2024.
//ITI.Shopify

import Foundation
import PassKit
var currencySymbol: String {
  return UserDefaults.standard.string(forKey: Constants.CURRENCY_KEY) ?? "USD"
}
class ApplePaymentStrategy: PaymentStrategy{

  private var paymentRequest: PKPaymentRequest = {
    let request = PKPaymentRequest()
    request.merchantIdentifier = "merchant.com.pushpendra.pay"
    request.supportedNetworks = [.visa, .masterCard, .girocard]
    request.supportedCountries = ["EG", "US"]
    request.merchantCapabilities = .capability3DS
    request.countryCode = String(currencySymbol.dropLast(1))
    request.currencyCode = currencySymbol

    return request
  }()

  
  func pay(amount: Double, vc: UIViewController) -> (Bool, String) {
    let formattedAmount = Double(String(format: "%.1f", amount)) ?? 0.0
    paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Shopify Cart", amount: NSDecimalNumber(value: formattedAmount))]
    let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
    controller?.delegate = (vc as! any PKPaymentAuthorizationViewControllerDelegate)
    vc.present(controller!, animated: true)
    return (true, "trying payment")
  }
}
