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
        self.tableView.layer.cornerRadius = 16
        self.tableView.layer.borderWidth = 0.5
        }
        // MARK: - Table view data source

      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectMethod(indexPath.row)

      }

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
      }

      func selectMethod(_ index: Int){
        switch index {
        case 0:
            print("card")
          cardImg.isHidden = false
          cardImg.isHidden = true
        default:
            print("cash")
          cashImg.isHidden = true
          cashImg.isHidden = false
        }
      }

    }
