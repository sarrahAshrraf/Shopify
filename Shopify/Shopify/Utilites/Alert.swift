//
//  Alert.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import Foundation
import UIKit

class Alert {
    
    func showAlertWithNegativeAndPositiveButtons(title: String, msg: String,negativeButtonTitle: String, positiveButtonTitle: String, negativeHandler: ((UIAlertAction)->())? = nil, positiveHandler:@escaping (UIAlertAction)->())-> UIAlertController{
        let alert : UIAlertController = UIAlertController(title: title, message:msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: negativeButtonTitle, style: .cancel, handler: negativeHandler))
        alert.addAction(UIAlertAction(title: positiveButtonTitle, style: .default, handler: positiveHandler))
        return alert
    }
    
    func showAlertWithPositiveButtons(title: String, msg: String, positiveButtonTitle: String, positiveHandler:((UIAlertAction)->())? = nil)-> UIAlertController{
        let alert : UIAlertController = UIAlertController(title: title, message:msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveButtonTitle, style: .default, handler: positiveHandler))
        return alert
    }
}
