//
//  PaymentVC.swift
//  Shopify
//
//  Created by sarrah ashraf on 12/06/2024.
//

import UIKit

class PaymentVC: UITableViewController {
    @IBOutlet weak var cashImg: UIImageView!
    @IBOutlet weak var cardImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cashImg.isHighlighted = true
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
            print("card")
            cashImg.isHighlighted = false
            cardImg.isHighlighted = true
        default:
            print("cash")
            cashImg.isHighlighted = true
              cardImg.isHighlighted = false

        }
      }

    }
