//
//  NibLoadableView.swift
//  Shopify
//
//  Created by Ahmed Refat on 13/06/2024.
//

import UIKit

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

extension UIView: NibLoadableView {}
