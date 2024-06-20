//
//  PaymentVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit

class PaymentVC: UITableViewController {
    
    
    @IBOutlet weak var cardCheck: UILabel!
    @IBOutlet weak var cashCheck: UILabel!
    @IBOutlet weak var cashImg: UIImageView!
    @IBOutlet weak var cardImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        cashImg.isHighlighted = true
        }
        // MARK: - Table view data source

      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         
        selectPaymentOption(indexPath.row)

      }

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
      }

      func selectPaymentOption(_ index: Int){
        switch index {
        case 0:
            cashCheck.isHidden = false
            cardCheck.isHidden = true
        default:
            cashCheck.isHidden = true
            cardCheck.isHidden = false

        }
      }

    }
