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
import Firebase


class SubscriptionViewController: UIViewController,SKPaymentTransactionObserver {
    
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var subDescriptionView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var ref:DatabaseReference!
    
    @IBOutlet weak var InitialInvestment: UILabel!
    @IBOutlet weak var TradingPeriod: UILabel!
    @IBOutlet weak var TotalNetProfit: UILabel!
    @IBOutlet weak var GrossProfit: UILabel!
    @IBOutlet weak var GrossLoss: UILabel!
    @IBOutlet weak var ProfitFactor: UILabel!
    @IBOutlet weak var TotalTrades: UILabel!
    @IBOutlet weak var WinningTrades: UILabel!
    @IBOutlet weak var LosingTrades: UILabel!
    @IBOutlet weak var AvgTradeNetProfit: UILabel!
    @IBOutlet weak var ReturnOnInitialInvestment: UILabel!
    @IBOutlet weak var AnnualizedReturn: UILabel!
    @IBOutlet weak var NumberOfSubscriptions: UILabel!
    
    @IBOutlet weak var subscriptionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        
        ref = Database.database().reference()
        
        hideLoginInformation()
        hideView()
        
//        showHideSignInStatus(false)
        
        setStatsValue()
        
        setCurrencySelectorButtonFormat(l:subscriptionButton)
            
        // Do any additional setup after loading the view.
        
    }
    
    func setStatsValue(){
        if let ss = K.defaults.array(forKey: "SubscribedStrats") as? [String]{
            if ss.count == 0 {
                return
            }
            
            NumberOfSubscriptions.text = String(ss.count)
            
            var II:Int = 0
            let TP:String = "Year 2020"
            var TNP:Double = 0.0
            var GP:Double = 0.0
            var GL:Double = 0.0
            var PF:Double = 0.0
            var TNT:Int = 0
            var WT:Int = 0
            var LT:Int = 0
            var ATNP:Double = 0.0
            var RIC:Double = 0.0
            var AR:Double = 0.0
            
            let m = StrategySubscriptionManager()
            for i in ss {
                for j in m.strategies {
                    if i == (j["Index"] as! String){
                        II = II + (j["Initial Investment"] as! Int)
                        TNP = TNP + (j["Total Net Profit"]  as! Double)
                        GP = GP + (j["Gross Profit"] as! Double)
                        GL = GL + (j["Gross Loss"] as! Double)
                        TNT = TNT + (j["Total Number of Trades"] as! Int)
                        WT = WT + (j["Winning Trades"] as! Int)
                        LT = LT + (j["Losing Trades"] as! Int)
                    }
                }
            }
            
            PF = GP/GL
            ATNP = TNP/Double(TNT)
            RIC = TNP/Double(II)*100
            AR = RIC*4/3
            
            InitialInvestment.text = "$" + String(II)
            TradingPeriod.text = TP
            TotalNetProfit.text = "$" + String(TNP)
            GrossProfit.text = "$" + String(GP)
            GrossLoss.text = "($" + String(GL) + ")"
            ProfitFactor.text = String(format: "%.1f",PF)
            TotalTrades.text = String(TNT)
            WinningTrades.text = String(WT)
            LosingTrades.text = String(LT)
            AvgTradeNetProfit.text = "$" + String(format: "%.1f",ATNP)
            ReturnOnInitialInvestment.text = String(format: "%.1f",RIC) + "%"
            AnnualizedReturn.text = String(format: "%.1f",AR) + "%"
            
        }
    }
    
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {
                authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                    let alert = UIAlertController(title: "ERROR", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    if let user = authResult?.user, let token = K.defaults.array(forKey: "FirebaseRegistrationToken"), let strats = K.defaults.array(forKey: "SubscribedStrats"){
                        self.ref.child("users").child(user.uid).setValue(["email":email,"token":token,"subscription":strats])
                        self.userNameButton.setTitle(String(email), for: .normal)
                        self.showHideSignInStatus(true)
                        print("success")
                        
                    }
                }
            }
        }
    }
  
    @IBAction func registerButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                    let alert = UIAlertController(title: "ERROR", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    if let user = authResult?.user, let token = K.defaults.array(forKey: "FirebaseRegistrationToken"), let strats = K.defaults.array(forKey: "SubscribedStrats"){
                        self.ref.child("users").child(user.uid).setValue(["email":email,"token":token,"subscription":strats])
                    self.userNameButton.setTitle(email, for: .normal)
                    self.showHideSignInStatus(true)
                    print("success")
                    }
                }
            }
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            showHideSignInStatus(false)
        }catch let signoutError as NSError{
            print("Error signing out: %@", signoutError)
        }
    }
    
    func showHideSignInStatus(_ s:Bool){
        emailTextField.isHidden = s
        passwordTextField.isHidden = s
        logInButton.isHidden = s
        RegisterButton.isHidden = s
        userNameButton.isHidden = !s
        logOutButton.isHidden = !s
    }
    
    
    @IBAction func makeSubFor3Pressed(_ sender: Any) {
        if !SKPaymentQueue.canMakePayments() {
            return
        }

        let paymentRequest = SKMutablePayment()
        //SKPaymentQueue.default().add(self)
        paymentRequest.productIdentifier = K.followAll
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.original?.payment.productIdentifier ?? "No product Identifier")
            if transaction.transactionState == .purchased {
                if let p = transaction.original?.payment.productIdentifier  {
                    print("updated based on \(p)")
                    switch p {
                    case K.follow3:
                        StrategySubscriptionManager.upperBound = 3
                        hideView()
                    case K.follow6:
                        StrategySubscriptionManager.upperBound = 6
                        hideView()
                    case K.followAll:
                        StrategySubscriptionManager.upperBound = 999
                        hideView()
                    default:
                        StrategySubscriptionManager.upperBound = 1
                        hideView()
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Transaction successful")
            }else if transaction.transactionState == .failed{
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Transaction failed")
            }
        }
        
//        if transactions.count > 0 {
//            let t = transactions[transactions.count-1]
//            if t.transactionState == .purchased {
//                if let p = t.original?.payment.productIdentifier  {
//                    print("updated based on \(p)")
//                    switch p {
//                    case K.follow3:
//                        StrategySubscriptionManager.upperBound = 3
//                        hideView()
//                    case K.follow6:
//                        StrategySubscriptionManager.upperBound = 6
//                        hideView()
//                    case K.followAll:
//                        StrategySubscriptionManager.upperBound = 999
//                        hideView()
//                    default:
//                        StrategySubscriptionManager.upperBound = 1
//                        hideView()
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func termsOfServicePressed(_ sender: Any) {
        let url = URL(string:K.termsCondition)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func privacyPolicyPressed(_ sender: Any) {
        let url = URL(string:K.privacyPolicy)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func hideLoginInformation(){

        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        logInButton.isHidden = true
        RegisterButton.isHidden = true
        userNameButton.isHidden = true
        logOutButton.isHidden = true
    }
    
    func hideView(){
        if StrategySubscriptionManager.upperBound > 1 {
            subDescriptionView.isHidden = true
            subscriptionView.isHidden = true
            logInView.isHidden = false
        }else{
            subDescriptionView.isHidden = false
            subscriptionView.isHidden = false
            logInView.isHidden = true
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
