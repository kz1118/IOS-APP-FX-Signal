//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 8/19/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation


class IndicatorManager {
    
    var URLstring = "https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol=EUR&to_symbol=USD&interval=5min&outputsize=full&apikey=X3HP908NIE0ZPV6N"
    
    var macd15m:String = "Gray"
    var macd30m:String = "Gray"
    var macd1h:String = "Gray"
    var macd4h:String = "Gray"
    var macdD:String = "Gray"
    var bb15m:String = "Gray"
    var bb30m:String = "Gray"
    var bb1h:String = "Gray"
    var bb4h:String = "Gray"
    var bbD:String = "Gray"
    var rsi15m:String = "Gray"
    var rsi30m:String = "Gray"
    var rsi1h:String = "Gray"
    var rsi4h:String = "Gray"
    var rsiD:String = "Gray"
    var stoch15m:String = "Gray"
    var stoch30m:String = "Gray"
    var stoch1h:String = "Gray"
    var stoch4h:String = "Gray"
    var stochD:String = "Gray"
    var adx15m:String = "Gray"
    var adx30m:String = "Gray"
    var adx1h:String = "Gray"
    var adx4h:String = "Gray"
    var adxD:String = "Gray"
    
    func calculateAll(){
        macd15m = calculateMACD()
        macd30m = calculateMACD()
        macd1h = calculateMACD()
        macd4h = calculateMACD()
        macdD = calculateMACD()
        bb15m = calculateBB()
        bb30m = calculateBB()
        bb1h = calculateBB()
        bb4h = calculateBB()
        bbD = calculateBB()
        rsi15m = calculateRSI()
        rsi30m = calculateRSI()
        rsi1h = calculateRSI()
        rsi4h = calculateRSI()
        rsiD = calculateRSI()
        stoch15m = calculateStoch()
        stoch30m = calculateStoch()
        stoch1h = calculateStoch()
        stoch4h = calculateStoch()
        stochD = calculateStoch()
        adx15m = calculateADX()
        adx30m = calculateADX()
        adx1h = calculateADX()
        adx4h = calculateADX()
        adxD = calculateADX()
    }
    
    func fetchAllIndicator() -> [String]{
        return [macd15m,macd30m,macd1h,macd4h,macdD,bb15m,bb30m,bb1h,bb4h,bbD,rsi15m,rsi30m,rsi1h,rsi4h,rsiD,stoch15m,stoch30m,stoch1h,stoch4h,stochD,adx15m,adx30m,adx1h,adx4h,adxD]
    }
    
    func performRequest() {
        let url = URL(string:URLstring)!
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
        
        task.resume()
    }
    
    func handle(data:Data?, response:URLResponse?, error:Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString ?? "")
        }
    }
    
    func calculateMACD() -> String {
       return "Red"
    }
    func calculateRSI() -> String {
       return "Gray"
    }
    func calculateADX() -> String {
       return "Green"
    }
    func calculateBB() -> String {
       return "Green"
    }
    func calculateStoch() -> String {
       return "Red"
    }
}


