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
    
    static let CurrencyPairs = ["AUDUSD","EURUSD","GBPUSD","USDJPY"]
    static let SupportedIndicators = ["MACD: 15m", "MACD: 30m","MACD: 1h","MACD: 4h","MACD: D",
        "BBand: 15m", "BBand: 30m","BBand: 1h","BBand: 4h","BBand: D",
        "RSI: 15m", "RSI: 30m","RSI: 1h","RSI: 4h","RSI: D",
        "Stoch: 15m", "Stoch: 30m","Stoch: 1h","Stoch: 4h","Stoch: D",
        "ADX: 15m", "ADX: 30m","ADX: 1h","ADX: 4h","ADX: D"]
    
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
    static let ButtonToIndicatorMapping:[String:String] = ["MACD: 15m":"macd15m", "MACD: 30m":"macd30m","MACD: 1h":"macd1h","MACD: 4h":"macd4h","MACD: D":"macdD",
    "BBand: 15m":"bband15m", "BBand: 30m":"bband30m","BBand: 1h":"bband1h","BBand: 4h":"bband4h","BBand: D":"bbandD",
    "RSI: 15m":"rsi15m", "RSI: 30m":"rsi30m","RSI: 1h":"rsi1h","RSI: 4h":"rsi4h","RSI: D":"rsiD",
    "Stoch: 15m":"stoch15m", "Stoch: 30m":"stoch30m","Stoch: 1h":"stoch1h","Stoch: 4h":"stoch4h","Stoch: D":"stochD",
    "ADX: 15m":"adx15m", "ADX: 30m":"adx30m","ADX: 1h":"adx1h","ADX: 4h":"adx4h","ADX: D":"adxD"]
    
    static let numberOfSelectedIndicator:Int = 5
    
    static let strategyCellIdentifier:String = "cellIdentifier"
    
    static let follow3:String = "MelodyX.FXSignal.PremiumSubscription"
    static let follow6:String = "MelodyX.FXSignal.PremiumSubscription2"
    static let followAll:String = "MelodyX.FXSignal.PremiumSubscription3"
    
}
