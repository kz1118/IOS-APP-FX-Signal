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
    let strategies: [[String:Any]] = [s1,s2,s3,s4]
    var subscribedStrats:[String] = ["mr4hAUD"]
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
    
    mutating func toSubscribe(id: Int){
        if subscribedStrats.contains(strategies[id]["Index"] as! String) {
            return
        }else if subscribedStrats.count >= StrategySubscriptionManager.upperBound {
            print("Reached the limit of the strategy number. Please subscribe to follow more strategies")
        }else{
            let temp:String = strategies[id]["Index"] as! String
            subscribedStrats.append(strategies[id]["Index"] as! String)
            Messaging.messaging().subscribe(toTopic: strategies[id]["Index"] as! String) {
                Error in
                print("subscribed to \(temp)")
            }
            K.defaults.set(subscribedStrats, forKey: "SubscribedStrats")
        }
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
        }
    }
    
    static func subscriptionValidation(){
        let receiptURL = Bundle.main.appStoreReceiptURL
        if let receipt = NSData(contentsOf: receiptURL!){
            let requestContents: [String:Any] = [
                "receipt-data":receipt.base64EncodedString(options: []),
                "password":"f1b4a6f65df840ac8e871d431506c485"
            ]
            let appleServer = receiptURL?.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
            let stringURL = "https://\(appleServer).itunes.apple.com/verifyReceipt"
            print ("Loading user receipt:\(stringURL)...")
            
            Alamofire.request(stringURL, method: .post, parameters: requestContents, encoding: JSONEncoding.default).responseJSON{ response in
                if let value = response.result.value as? NSDictionary {
                    for i in (value["latest_receipt_info"] as! NSArray){
                        if let expiry = (i as! NSDictionary)["expires_date"] {
                            let UTCDate = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatter.timeZone = TimeZone(secondsFromGMT:0)
                            let defaultTimeZoneStr = formatter.string(from: UTCDate)
                            if( defaultTimeZoneStr < expiry as! String){
                                if let p = (i as! NSDictionary)["product_id"]{
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
}

let s1:[String:Any] = [ "Id":1, "Index": "mr4hAUD", "Description": "Mean Reversion - Currency Pair:AUDUSD, Timeframe: 4H", "Subscription":false]

let s2:[String:Any]  = [ "Id":2, "Index": "mr4hEUR", "Description": "Mean Reversion - Currency Pair:EURUSD, Timeframe: 4H", "Subscription":false]

let s3:[String:Any] = [ "Id":3, "Index": "mr4hGBP", "Description": "Mean Reversion - Currency Pair:GBPUSD, Timeframe: 4H", "Subscription":false]

let s4:[String:Any] = [ "Id": 4, "Index": "mr4hJPY", "Description": "Mean Reversion - Currency Pair: USDJPY, Timeframe: 4H", "Subscription":false]


