//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 9/9/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import Alamofire

struct StrategySubscriptionManager {
    let strategies: [[String:Any]] = [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12]
    var subscribedStrats:[String] = []
    static var upperBound:Int = 1
    
    mutating func loadSubscribedStrats(){
        if let ss = K.defaults.array(forKey: "SubscribedStrats") as? [String]{
            subscribedStrats = ss
        }
    }
    
    func subscribeAndListen(){
        if subscribedStrats.count > 0 {
            for i in subscribedStrats {
                Messaging.messaging().subscribe(toTopic: i) {Error in
                    print("subscribed to \(i)")
                }
            }
        }
    }
    
    mutating func toSubscribe(id: Int)->Bool{
        if subscribedStrats.contains(strategies[id]["Index"] as! String) {
            return true
        }else if subscribedStrats.count >= StrategySubscriptionManager.upperBound {
            print("Reached the limit of the strategy number. Please subscribe to follow more strategies")
            return false
        }else{
            let temp:String = strategies[id]["Index"] as! String
            subscribedStrats.append(strategies[id]["Index"] as! String)
            Messaging.messaging().subscribe(toTopic: strategies[id]["Index"] as! String) {
                Error in
                print("subscribed to \(temp)")
            }
            K.defaults.set(subscribedStrats, forKey: "SubscribedStrats")
            saveToFirebase()
        }
        
        return true
    }
    
    mutating func toUnsubscribe(id: Int){
        if let index =  subscribedStrats.firstIndex(of: strategies[id]["Index"] as! String) {
            let temp:String = subscribedStrats[index] 
            subscribedStrats.remove(at: index)
            Messaging.messaging().unsubscribe(fromTopic: temp){
                Error in
                print("unsubscribed to \(temp)")
            }
            K.defaults.set(subscribedStrats, forKey: "SubscribedStrats")
            saveToFirebase()
        }
    }
    
    func saveToFirebase(){
        
        if let token = K.defaults.array(forKey: "FirebaseRegistrationToken"), let strats = K.defaults.array(forKey: "SubscribedStrats") {
            let ref = Database.database().reference()
            let u = "WoEmail"+(token[0] as! String).prefix(10)
            let currentDate = Date()
            let format1 = DateFormatter()
            format1.dateStyle = .short
            let d = format1.string(from: currentDate)
            ref.child("users").child(u).setValue(["date":d, "email":"fxstrategy@fxstrategy.com","token":token,"subscription":strats])
        }
    }
    
//    static func subscriptionValidation(){
//     //   print("CCCCCC-----")
//     //   sleep(2)
//
//        let receiptURL = Bundle.main.appStoreReceiptURL
//        if let receipt = NSData(contentsOf: receiptURL!){
//            let requestContents: [String:Any] = [
//                "receipt-data":receipt.base64EncodedString(options: []),
//                "password":"f1b4a6f65df840ac8e871d431506c485"
//              //  "password":"f1b4a6f65df840ac8e871d43485"
//            ]
//            let appleServer = receiptURL?.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
//            let stringURL = "https://\(appleServer).itunes.apple.com/verifyReceipt"
//            print ("Loading user receipt:\(stringURL)...")
//
//            Alamofire.request(stringURL, method: .post, parameters: requestContents, encoding: JSONEncoding.default).responseJSON{ response in
//                if let value = response.result.value as? NSDictionary {
//                    for i in (value["latest_receipt_info"] as! NSArray){
//                        if let expiry = (i as! NSDictionary)["expires_date"] {
//                            let UTCDate = Date()
//                            let formatter = DateFormatter()
//                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                            formatter.timeZone = TimeZone(secondsFromGMT:0)
//                            let defaultTimeZoneStr = formatter.string(from: UTCDate)
//                            if( defaultTimeZoneStr < expiry as! String){
//                                if let p = (i as! NSDictionary)["product_id"]{
//                                    print(p)
//                                    switch p as! String {
//                                    case K.follow3:
//                                        upperBound = 3
//                                    case K.follow6:
//                                        upperBound = 6
//                                    case K.followAll:
//                                        upperBound = 999
//                                    default:
//                                        upperBound = 1
//                                    }
//                                    print(upperBound)
//                                }
//                            }
//                        }
//                    }
//
//                    unsubscribeIfNeccessary()
//
//                }else{
//                    print("receive response failed")
//                }
//            }
//        }
//   //     print("DDDDD-----")
//   //     sleep(2)
//    }
    
    static func unsubscribeIfNeccessary(){
        if var ss = K.defaults.array(forKey: "SubscribedStrats") as? [String]{
            if ss.count <= upperBound{
                return
            }
            
            let n:Int = ss.count - upperBound
            
            for _ in 1...n {
                let i = ss.remove(at: 0)
                Messaging.messaging().unsubscribe(fromTopic: i){
                    Error in
                    print("unsubscribed to \(i)")
                }
            }
            
            K.defaults.set(ss, forKey: "SubscribedStrats")
            
        }
    }
    
    static func subscriptionValidation(){

        guard let receiptURL = Bundle.main.appStoreReceiptURL else{
            upperBound = 1
            print("receiptURL generating fail")
            return
        }

        if let receipt = NSData(contentsOf: receiptURL){
            let requestContents: [String:Any] = [
                "receipt-data":receipt.base64EncodedString(options: []),
                "password":"f1b4a6f65df840ac8e871d431506c485"
            //    "password":"f1b4a6f65df840ac8e871d43485"
            ]
            let appleServer = receiptURL.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
            let stringURL = "https://\(appleServer).itunes.apple.com/verifyReceipt"
            print ("Loading user receipt:\(stringURL)...")

            Alamofire.request(stringURL, method: .post, parameters: requestContents, encoding: JSONEncoding.default).responseJSON{ response in

                if let value = response.result.value as? Dictionary<String, Any> {

                    guard let receiptArray = value["latest_receipt_info"] as? [Dictionary<String, Any>] else {
                        print("Receipt generation is wrong")
                        upperBound = 1
                        return
                    }

                    for i in receiptArray{
                        if let expiry = i["expires_date"] {
                            let UTCDate = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatter.timeZone = TimeZone(secondsFromGMT:0)
                            let defaultTimeZoneStr = formatter.string(from: UTCDate)
                            if( defaultTimeZoneStr < expiry as! String){
                                if let p = i["product_id"]{
                                    print(p)
                                    switch p as! String {
                                    case K.follow3:
                                        upperBound = 3
                                    case K.follow6:
                                        upperBound = 6
                                    case K.followAll:
                                        upperBound = 999
                                    default:
                                        upperBound = 1
                                    }
                                    print(upperBound)
                                }
                            }
                        }
                    }

                    unsubscribeIfNeccessary()

                }else{
                    print("receive response failed")
                }
            }
        }

    }
    
}

let s1:[String:Any]  = [ "Id":1, "Index": "mm4hJPY", "Description": "Momentum - Currency Pair:USDJPY, Timeframe: 4H", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 1103.8, "Gross Profit": 3358.4, "Gross Loss": 2254.5, "Profit Factor": 1.49, "Total Number of Trades": 75, "Winning Trades":34, "Losing Trades": 41, "Avg. Trade Net Profit": 14.72, "Return on Initial Capital":11.04, "Annualized Return":14.72]

let s2:[String:Any] = [ "Id":2, "Index": "mm4hGBP", "Description": "Momentum - Currency Pair:GBPUSD, Timeframe: 4H", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 1341.8, "Gross Profit": 3341.5, "Gross Loss": 1999.7, "Profit Factor": 1.67, "Total Number of Trades": 54, "Winning Trades":26, "Losing Trades": 28, "Avg. Trade Net Profit": 25.8, "Return on Initial Capital":13.42, "Annualized Return":17.89]

let s3:[String:Any] = [ "Id":3, "Index": "mm4hNZD", "Description": "Momentum - Currency Pair:NZDUSD, Timeframe: 4H", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 678.1, "Gross Profit": 1507.1, "Gross Loss": 828.9, "Profit Factor": 1.82, "Total Number of Trades": 66, "Winning Trades":34, "Losing Trades": 32, "Avg. Trade Net Profit": 10.27, "Return on Initial Capital":6.78, "Annualized Return":9.04]

let s4:[String:Any]  = [ "Id":4, "Index": "mmDJPY", "Description": "Momentum - Currency Pair:USDJPY, Timeframe: D", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 1026.9, "Gross Profit": 1619.0, "Gross Loss": 592.1, "Profit Factor": 2.73, "Total Number of Trades": 33, "Winning Trades":19, "Losing Trades": 14, "Avg. Trade Net Profit": 31.12, "Return on Initial Capital":10.27, "Annualized Return":13.69]

let s5:[String:Any] = [ "Id":5, "Index": "mmDGBP", "Description": "Momentum - Currency Pair:GBPUSD, Timeframe: D", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 1229.8, "Gross Profit": 2571.6, "Gross Loss": 1341.8, "Profit Factor": 1.92, "Total Number of Trades": 31, "Winning Trades":19, "Losing Trades": 12, "Avg. Trade Net Profit": 39.67, "Return on Initial Capital":12.30, "Annualized Return":16.40]


let s6:[String:Any] = [ "Id":6, "Index": "mr30mAUD", "Description": "Mean Reversion - Currency Pair:AUDUSD, Timeframe: 30M", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 736.1, "Gross Profit": 1502.8, "Gross Loss": 766.7, "Profit Factor": 1.96, "Total Number of Trades": 53, "Winning Trades":38, "Losing Trades": 15, "Avg. Trade Net Profit": 13.89, "Return on Initial Capital":7.36, "Annualized Return":9.81]

let s7:[String:Any]  = [ "Id":7, "Index": "mr30mEUR", "Description": "Mean Reversion - Currency Pair:EURUSD, Timeframe: 30M", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 265.2, "Gross Profit": 1254.9, "Gross Loss": 989.7, "Profit Factor": 1.27, "Total Number of Trades": 67, "Winning Trades":41, "Losing Trades": 26, "Avg. Trade Net Profit": 3.96, "Return on Initial Capital":2.65, "Annualized Return":3.54]

let s8:[String:Any] = [ "Id":8, "Index": "mr30mGBP", "Description": "Mean Reversion - Currency Pair:GBPUSD, Timeframe: 30M", "Subscription":false, "Initial Investment":10000, "Trading Period":"Year 2020", "Total Net Profit": 390.9, "Gross Profit": 1708.8, "Gross Loss": 1317.9, "Profit Factor": 1.30, "Total Number of Trades": 52, "Winning Trades":30, "Losing Trades": 22, "Avg. Trade Net Profit": 7.52, "Return on Initial Capital":3.91, "Annualized Return":5.21]



let s9:[String:Any] = [ "Id": 10, "Index": "mm4hCAD", "Description": "Momentum - Currency Pair: USDCAD, Timeframe: 4H (Release soon)", "Subscription":false, "Initial Investment":0, "Trading Period":"Year 2020", "Total Net Profit": 0.0, "Gross Profit": 0.0, "Gross Loss": 0.0, "Profit Factor": 0.0, "Total Number of Trades": 0, "Winning Trades":0, "Losing Trades": 0, "Avg. Trade Net Profit": 0.0, "Return on Initial Capital":0.0, "Annualized Return":0.0]

let s10:[String:Any] = [ "Id": 9, "Index": "mr30mCAD", "Description": "Mean Reversion - Currency Pair:USDCAD, Timeframe: 30M (Release soon)", "Subscription":false, "Initial Investment":0, "Trading Period":"Year 2020", "Total Net Profit": 0.0, "Gross Profit": 0.0, "Gross Loss": 0.0, "Profit Factor": 0.0, "Total Number of Trades": 0, "Winning Trades":0, "Losing Trades": 0, "Avg. Trade Net Profit": 0.0, "Return on Initial Capital":0.0, "Annualized Return":0.0]

let s11:[String:Any] = [ "Id": 11, "Index": "mm4hEUR", "Description": "Momentum - Currency Pair: EURUSD, Timeframe: 4H (Release soon)", "Subscription":false, "Initial Investment":0, "Trading Period":"Year 2020", "Total Net Profit": 0.0, "Gross Profit": 0.0, "Gross Loss": 0.0, "Profit Factor": 0.0, "Total Number of Trades": 0, "Winning Trades":0, "Losing Trades": 0, "Avg. Trade Net Profit": 0.0, "Return on Initial Capital":0.0, "Annualized Return":0.0]

let s12:[String:Any] = [ "Id": 12, "Index": "mr30mNZD", "Description": "Mean Reversion - Currency Pair:NZDUSD, Timeframe: 30M (Release soon)", "Subscription":false, "Initial Investment":0, "Trading Period":"Year 2020", "Total Net Profit": 0.0, "Gross Profit": 0.0, "Gross Loss": 0.0, "Profit Factor": 0.0, "Total Number of Trades": 0, "Winning Trades":0, "Losing Trades": 0, "Avg. Trade Net Profit": 0.0, "Return on Initial Capital":0.0, "Annualized Return":0.0]


