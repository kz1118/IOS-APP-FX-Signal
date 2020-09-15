//
//  SubscriptionViewController.swift
//  FXSignal
//
//  Created by Lisa on 9/10/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire


class SubscriptionViewController: UIViewController,SKPaymentTransactionObserver {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func makeSubFor3Pressed(_ sender: Any) {
        if !SKPaymentQueue.canMakePayments() {
            return
        }

        let paymentRequest = SKMutablePayment()
        SKPaymentQueue.default().add(self)
        paymentRequest.productIdentifier = K.follow3
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.original?.payment.productIdentifier ?? "No product Identifier")
            if transaction.transactionState == .purchased {
                print("Transaction successful")
            }else{
                print("Transaction failed")
            }
        }
        
        if transactions.count > 0 {
            let t = transactions[transactions.count-1]
            if t.transactionState == .purchased {
                if let p = t.original?.payment.productIdentifier  {
                    print("updated based on \(p)")
                    switch p {
                    case K.follow3:
                        StrategySubscriptionManager.upperBound = 3
                    case K.follow6:
                        StrategySubscriptionManager.upperBound = 6
                    case K.followAll:
                        StrategySubscriptionManager.upperBound = 999
                    default:
                        StrategySubscriptionManager.upperBound = 1
                    }
                }
            }
        }
    }
    

 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
