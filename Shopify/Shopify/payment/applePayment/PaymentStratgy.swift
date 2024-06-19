//
//  PaymentStratgy.swift
//  Shopify
//
//  Created by sarrah ashraf on 19/06/2024.
//

import Foundation
import PassKit
protocol PaymentStrategy{
  func pay(amount: Double, vc: UIViewController) -> (Bool, String)
}
