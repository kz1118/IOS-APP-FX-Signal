//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 8/19/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation

protocol IndicatorManagerDelegate {
    func didUpdateIndicators(im:IndicatorModel)
}

struct IndicatorModel {
    
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
    
    var highTs : [Float] = []
    var lowTs : [Float] = []
    var openTs: [Float] = []
    var closeTs: [Float] = []
    
    var lastRefreshed: String = ""
    
    var currency:String = ""
    
    var buySignal:String = "N/A"
    var sellSignal:String = "N/A"
    
    func fetchAllIndicator() -> [String]{
        return[macd15m,macd30m,macd1h,macd4h,macdD,bb15m,bb30m,bb1h,bb4h,bbD,rsi15m,rsi30m,rsi1h,rsi4h,rsiD,stoch15m,stoch30m,stoch1h,stoch4h,stochD,adx15m,adx30m,adx1h,adx4h,adxD]
    }
    
    func fetchAllIndicatorInDict() -> [String:String] {
        return ["macd15m":macd15m,"macd30m":macd30m,"macd1h":macd1h,"macd4h":macd4h,"macdD":macdD,"bband15m":bb15m,"bband30m":bb30m,"bband1h":bb1h,"bband4h":bb4h,"bbandD":bbD,"rsi15m":rsi15m,"rsi30m":rsi30m,"rsi1h":rsi1h,"rsi4h":rsi4h,"rsiD":rsiD,"stoch15m":stoch15m,"stoch30m":stoch30m,"stoch1h":stoch1h,"stoch4h":stoch4h,"stochD":stochD,"adx15m":adx15m,"adx30m":adx30m,"adx1h":adx1h,"adx4h":adx4h,"adxD":adxD]
    }
}

class IndicatorManager {
    
    var delegate:IndicatorManagerDelegate?
    
    var URLstring:String = ""
    
    var im: IndicatorModel = IndicatorModel()
    
    var strategies:[Strategy] = []
    
    init(c:String){
        im.currency = c
        URLstring = "https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol="+im.currency.prefix(3)+"&to_symbol="+im.currency.suffix(3)+"&interval=15min&outputsize=full&apikey=X3HP908NIE0ZPV6N"
    }
    
    func setCurrency(c:String){
        im.currency = c
        URLstring = "https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol="+im.currency.prefix(3)+"&to_symbol="+im.currency.suffix(3)+"&interval=15min&outputsize=full&apikey=X3HP908NIE0ZPV6N"
    }
    
    func calculateAll(){
        im.macd15m = calculateMACD()
        im.macd30m = calculateMACD()
        im.macd1h = calculateMACD()
        im.macd4h = calculateMACD()
        im.macdD = calculateMACD()
        im.bb15m = calculateBB()
        im.bb30m = calculateBB()
        im.bb1h = calculateBB()
        im.bb4h = calculateBB()
        im.bbD = calculateBB()
        im.rsi15m = calculateRSI()
        im.rsi30m = calculateRSI()
        im.rsi1h = calculateRSI()
        im.rsi4h = calculateRSI()
        im.rsiD = calculateRSI()
        im.stoch15m = calculateStoch()
        im.stoch30m = calculateStoch()
        im.stoch1h = calculateStoch()
        im.stoch4h = calculateStoch()
        im.stochD = calculateStoch()
        im.adx15m = calculateADX()
        im.adx30m = calculateADX()
        im.adx1h = calculateADX()
        im.adx4h = calculateADX()
        im.adxD = calculateADX()
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
            im.highTs.removeAll()
            im.lowTs.removeAll()
            im.openTs.removeAll()
            im.closeTs.removeAll()
            
            parseJson(fxData: safeData)
            calculateAll()
            
            im.buySignal = getBuySignalLabel()
            im.sellSignal = getSellSignalLabel()
        
            delegate?.didUpdateIndicators(im: self.im)
        }
    }
    
    func parseJson(fxData:Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FXData.self, from: fxData)
            let info = decodedData.metaData
            let ts = decodedData.timeSeries
            let sortedDates =  Array(ts.keys).sorted(by: <)
            im.lastRefreshed = info[K.LastRefreshed]!
 
            for d in sortedDates {
                im.highTs.append(Float(ts[d]![K.HighKey]!)!)
                im.lowTs.append(Float(ts[d]![K.LowKey]!)!)
                im.openTs.append(Float(ts[d]![K.OpenKey]!)!)
                im.closeTs.append(Float(ts[d]![K.CloseKey]!)!)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func loadDefault(){
        if let data = try? Data(contentsOf: K.dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                strategies = try decoder.decode([Strategy].self, from: data)
            }catch{
                print("Error detected")
            }
        }
    }
    
    func getBuySignalLabel()->String{
        for i in strategies{
            if i.currency == im.currency && i.buySell == "BUY" {
                let signal = checkBuySignal(s:i)
                if(signal == true ){
                    return "Active"
                }else{
                    return "Inactive"
                }
            }
        }
        return "N/A"
    }
    
    func checkBuySignal(s:Strategy)->Bool{
        var sum:Int = 0
        let dict:[String:String] = im.fetchAllIndicatorInDict()
        
        if dict[s.ind1.name] == "Green" {
            sum = sum + s.ind1.weight
        }
        if dict[s.ind2.name] == "Green" {
            sum = sum + s.ind2.weight
        }
        if dict[s.ind3.name] == "Green" {
            sum = sum + s.ind3.weight
        }
        if dict[s.ind4.name] == "Green" {
            sum = sum + s.ind4.weight
        }
        if dict[s.ind5.name] == "Green" {
            sum = sum + s.ind5.weight
        }
        
        if sum >= s.threshold{
            return true
        }else{
            return false
        }
    }

    func getSellSignalLabel()->String{
        for i in strategies{
            if i.currency == im.currency && i.buySell == "SELL" {
                let signal = checkSellSignal(s:i)
                if(signal == true ){
                    return "Active"
                }else{
                    return "Inactive"
                }
            }
        }
        return "N/A"
    }
    
    func checkSellSignal(s:Strategy)->Bool{
        var sum:Int = 0
        let dict:[String:String] = im.fetchAllIndicatorInDict()
        if dict[s.ind1.name] == "Red" {
            sum = sum + s.ind1.weight
        }
        if dict[s.ind2.name] == "Red" {
            sum = sum + s.ind2.weight
        }
        if dict[s.ind3.name] == "Red" {
            sum = sum + s.ind3.weight
        }
        if dict[s.ind4.name] == "Red" {
            sum = sum + s.ind4.weight
        }
        if dict[s.ind5.name] == "Red" {
            sum = sum + s.ind5.weight
        }
        
        if sum >= s.threshold{

            return true
        }else{
            return false
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


