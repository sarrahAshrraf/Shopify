//
//  Utilities.swift
//  Shopify
//
//  Created by sarrah ashraf on 18/06/2024.
//

import Foundation
import UIKit

class Utilities{
    static func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
    
    static func navigateToGuestScreen(viewController: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let guestVC = storyboard.instantiateViewController(identifier: "GuestViewController") as! GuestViewController
        guestVC.modalPresentationStyle = .fullScreen
        guestVC.modalTransitionStyle = .crossDissolve
        viewController.present(guestVC, animated: true)
    }
}
