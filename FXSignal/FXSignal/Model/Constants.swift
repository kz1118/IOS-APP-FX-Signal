//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 8/20/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation
import UIKit

struct K {
    
    static let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Strategies.plist")
    
    static let defaults = UserDefaults.standard
    
    static let CurrencyPairs = ["AUDUSD","EURUSD","GBPUSD","USDCHF","USDCAD","USDJPY"]
    static let SupportedIndicators = ["MACD: 15m", "MACD: 30m","MACD: 1h","MACD: 4h","MACD: 12h",
        "BBand: 15m", "BBand: 30m","BBand: 1h","BBand: 4h","BBand: 12h",
        "RSI: 15m", "RSI: 30m","RSI: 1h","RSI: 4h","RSI: 12h",
        "Stoch: 15m", "Stoch: 30m","Stoch: 1h","Stoch: 4h","Stoch: 12h",
        "SMA: 15m", "SMA: 30m","SMA: 1h","SMA: 4h","SMA: 12h"]
    
    static let OpenKey: String = "1. open"
    static let HighKey: String = "2. high"
    static let LowKey: String = "3. low"
    static let CloseKey: String = "4. close"
    static let LastRefreshed: String = "4. Last Refreshed"
    
    struct RedColor{
        static let topRed:CGFloat = 234.0/255.0
        static let topGreen: CGFloat = 52.0/255.0
        static let topBlue: CGFloat = 46.0/255.0
        static let bottomRed:CGFloat = 148.0/255.0
        static let bottomGreen: CGFloat = 35.0/255.0
        static let bottomBlue: CGFloat = 29.0/255.0
    }
    
    struct GreenColor{
        static let topRed:CGFloat = 0.0/255.0
        static let topGreen: CGFloat = 249.0/255.0
        static let topBlue: CGFloat = 0.0/255.0
        static let bottomRed:CGFloat = 0.0/255.0
        static let bottomGreen: CGFloat = 160.0/255.0
        static let bottomBlue: CGFloat = 2.0/255.0
    }
    
    struct GrayColor{
        static let topRed:CGFloat = 219.0/255.0
        static let topGreen: CGFloat = 219.0/255.0
        static let topBlue: CGFloat = 227.0/255.0
        static let bottomRed:CGFloat = 156.0/255.0
        static let bottomGreen: CGFloat = 155.0/255.0
        static let bottomBlue: CGFloat = 164.0/255.0
    }
    // indicator name to the indicator button in the strategy configuration
    // Due to historical reason, I change the Daily value to 12h value, and ADX to SMA. To keep it consistent, the indicator name still uses the old one (adx and d), but only shows on screen, with the correct one. All calculation is based on sma and 12h.
    static let ButtonToIndicatorMapping:[String:String] = ["MACD: 15m":"macd15m", "MACD: 30m":"macd30m","MACD: 1h":"macd1h","MACD: 4h":"macd4h","MACD: 12h":"macdD",
    "BBand: 15m":"bband15m", "BBand: 30m":"bband30m","BBand: 1h":"bband1h","BBand: 4h":"bband4h","BBand: 12h":"bbandD",
    "RSI: 15m":"rsi15m", "RSI: 30m":"rsi30m","RSI: 1h":"rsi1h","RSI: 4h":"rsi4h","RSI: 12h":"rsiD",
    "Stoch: 15m":"stoch15m", "Stoch: 30m":"stoch30m","Stoch: 1h":"stoch1h","Stoch: 4h":"stoch4h","Stoch: 12h":"stochD",
    "SMA: 15m":"adx15m", "SMA: 30m":"adx30m","SMA: 1h":"adx1h","SMA: 4h":"adx4h","SMA: 12h":"adxD"]
    
    static let numberOfSelectedIndicator:Int = 5
    static let numberOfSignals:Int = 20
    
    static let apiKey:String = "0RV9BVMV42VOG8VB"
    
    static let privacyPolicy:String = "https://docs.google.com/document/d/1cNsCCs9bkTKZh6rDBmEIudAxwAmsydVk9g3h3bnpuZo/edit?usp=sharing"
    
    static let termsCondition:String = "https://docs.google.com/document/d/1N_UDiJ2dYS1Udl-j3RkgMCZlyF86_64nAxDnJS6a7xY/edit?usp=sharing"
    
    static let strategyCellIdentifier:String = "cellIdentifier"
    static let signalCellIdentifier:String = "SignalCell"
    
    static let follow3:String = "MelodyX.FXSignal.PremiumSubscription"
    static let follow6:String = "MelodyX.FXSignal.PremiumSubscription2"
    static let followAll:String = "MelodyX.FXSignal.PremiumSubscription3"
    
    static let strategyConfigMessage:String = "Step 1: Select indicators with weights in your strategy \n Step 2: Choose the threshold for your strategy \n Step 3: BUY(SELL) Signal are triggered once the sum of weights for the indicators which show BUY(SELL) is greater than the threshold"
    static let reachUpperBoundMessage:String = "Reach the limit of the number of strategies. Please go to Subscription tab to subscribe to follow more strategies"
    static let strategySelectMessage = "1. Review each strategy performance \n 2. Select one strategy to follow FOR FREE! \n 3. Subscribe to follow more strategies! \n 4. BUY/SELL signal will be sent through Notification for every subscribed strategy"
    static let monitorViewMessage = "1. Click refresh button or switch currency pair to get up-to-date exchange rate and indications \n 2. Click CUSTOMIZE button to configure your strategy \n 3. Buy/Sell Signal will show Active when the entry condition is met in your strategy"
    
}
