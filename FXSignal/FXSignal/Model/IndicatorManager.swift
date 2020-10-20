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
// Note: All "D" does not mean Day, but means "12h", also "adx" actually "sma"
    
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
        URLstring = "https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol="+im.currency.prefix(3)+"&to_symbol="+im.currency.suffix(3)+"&interval=15min&outputsize=full&apikey="+K.apiKey
    }
    
    func setCurrency(c:String){
        im.currency = c
        URLstring = "https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol="+im.currency.prefix(3)+"&to_symbol="+im.currency.suffix(3)+"&interval=15min&outputsize=full&apikey="+K.apiKey
    }
    
    func generateData(ts:[Float],tf: String) -> [Float]{
// Note: All "D" does not mean Day, but means "12h", also "adx" actually "sma"
   
        let ts_r: [Float] = ts.reversed()

        var interval:Int = 1
        
        switch tf {
        case "15m":
            interval = 1
        case "30m":
            interval = 2
        case "1h":
            interval = 4
        case "4h":
            interval = 16
        case "12h":
            interval = 48
        default:
            interval = 1
        }
        
        let count:Int = Int((ts_r.count-1)/interval)
        var result:[Float] = []
        for i in 0...count {
            result.append(ts_r[i*interval])
        }

      //  print(result.count)
        
        return result
    }
    
    func calculateAll(){
// Note: All "D" does not mean Day, but means "12h", also "adx" actually "sma"
        let close15m: [Float] = generateData(ts: im.closeTs,tf: "15m")
        let close30m: [Float] = generateData(ts: im.closeTs,tf: "30m")
        let close1h: [Float] = generateData(ts: im.closeTs,tf: "1h")
        let close4h: [Float] = generateData(ts: im.closeTs,tf: "4h")
        let close12h: [Float] = generateData(ts: im.closeTs,tf: "12h")
        let high15m: [Float] = generateData(ts: im.highTs,tf: "15m")
        let high30m: [Float] = generateData(ts: im.highTs,tf: "30m")
        let high1h: [Float] = generateData(ts: im.highTs,tf: "1h")
        let high4h: [Float] = generateData(ts: im.highTs,tf: "4h")
        let high12h: [Float] = generateData(ts: im.highTs,tf: "12h")
        let low15m: [Float] = generateData(ts: im.lowTs,tf: "15m")
        let low30m: [Float] = generateData(ts: im.lowTs,tf: "30m")
        let low1h: [Float] = generateData(ts: im.lowTs,tf: "1h")
        let low4h: [Float] = generateData(ts: im.lowTs,tf: "4h")
        let low12h: [Float] = generateData(ts: im.lowTs,tf: "12h")
        let open15m: [Float] = generateData(ts: im.openTs,tf: "15m")
        let open30m: [Float] = generateData(ts: im.openTs,tf: "30m")
        let open1h: [Float] = generateData(ts: im.openTs,tf: "1h")
        let open4h: [Float] = generateData(ts: im.openTs,tf: "4h")
        let open12h: [Float] = generateData(ts: im.openTs,tf: "12h")
        
        im.macd15m = calculateMACD(ts:close15m)
        im.macd30m = calculateMACD(ts:close30m)
        im.macd1h = calculateMACD(ts:close1h)
        im.macd4h = calculateMACD(ts:close4h)
        im.macdD = calculateMACD(ts:close12h)
        im.bb15m = calculateBB(cts:close15m,hts:high15m,lts:low15m)
        im.bb30m = calculateBB(cts:close30m,hts:high30m,lts:low30m)
        im.bb1h = calculateBB(cts:close1h,hts:high1h,lts:low1h)
        im.bb4h = calculateBB(cts:close4h,hts:high4h,lts:low4h)
        im.bbD = calculateBB(cts:close12h,hts:high12h,lts:low12h)
        im.rsi15m = calculateRSI(ts:close15m)
        im.rsi30m = calculateRSI(ts:close30m)
        im.rsi1h = calculateRSI(ts:close1h)
        im.rsi4h = calculateRSI(ts:close4h)
        im.rsiD = calculateRSI(ts:close12h)
        im.stoch15m = calculateStoch(cts:close15m,hts:high15m,lts:low15m)
        im.stoch30m = calculateStoch(cts:close30m,hts:high30m,lts:low30m)
        im.stoch1h = calculateStoch(cts:close1h,hts:high1h,lts:low1h)
        im.stoch4h = calculateStoch(cts:close4h,hts:high4h,lts:low4h)
        im.stochD = calculateStoch(cts:close12h,hts:high12h,lts:low12h)
        im.adx15m = calculateADX(ts:close15m)
        im.adx30m = calculateADX(ts:close30m)
        im.adx1h = calculateADX(ts:close1h)
        im.adx4h = calculateADX(ts:close4h)
        im.adxD = calculateADX(ts:close12h)
    }
    

    
    func performRequest() {
        let url = URL(string:URLstring)!
        
        let session = URLSession(configuration: .default)
    //    print("JJJJJ----")
    //    sleep(5)
        let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
    //    print("KKKK----")
    //    sleep(5)
        task.resume()
    }
    
    func handle(data:Data?, response:URLResponse?, error:Error?){
     //   print("LLLL----")
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data{
            im.highTs.removeAll()
            im.lowTs.removeAll()
            im.openTs.removeAll()
            im.closeTs.removeAll()
            
            let parseResult = parseJson(fxData: safeData)
            if (parseResult == false){
                return
            }
            calculateAll()
            
            im.buySignal = getBuySignalLabel()
            im.sellSignal = getSellSignalLabel()
        
            delegate?.didUpdateIndicators(im: self.im)
        }
    }
    
    func parseJson(fxData:Data) -> Bool {
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
            
            return true
            
        } catch  {
            print(error)
         //   print("EEE")
            return false
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

    
    func calculateMACD(ts:[Float]) -> String {
        if ts.count < 35 {
            return "Gray"
        }
        
        var df:Float = 0.0
        var df1:Float = 0.0
        var macd:Float = 0.0
        var macd1:Float = 0.0
        
        for i in 0...9{
            var ma26:Float = 0.0
            var ma12:Float = 0.0
            for j in 0...25{
                ma26 = ma26 + ts[i+j]/26.0
            }
            for k in 0...11{
                ma12 = ma12 + ts[i+k]/12.0
            }
            if i == 0{
                df = ma12 - ma26
            }
            if i == 1{
                df1 = ma12 - ma26
            }
            
            if i == 0 {
                macd = (ma12-ma26)/9.0 + macd
            }else if i == 9 {
                macd1 = (ma12-ma26)/9.0 + macd1
            }else{
                macd = (ma12-ma26)/9.0 + macd
                macd1 = (ma12-ma26)/9.0 + macd1
            }
        }
        
        if df > macd && (df-macd) > (df1-macd1) {
            return "Green"
        }
        else if df < macd && (df-macd) < (df1-macd1) {
            return "Red"
        }else{
            return "Gray"
        }
    }
    
    
    func calculateRSI(ts:[Float]) -> String {
        
        if ts.count < 15 {
            return "Gray"
        }
        var gain:Double = 0.0
        var loss:Double = 0.0
        var rs:Double = 0.0
        var rsi:Double = 0.0
        
        for i in 0...13{
            if ts[i] > ts[i+1]{
                gain = Double(gain + Double(ts[i]) - Double(ts[i+1]))
            }else{
                loss = Double(loss + Double(ts[i+1]) - Double(ts[i]))
            }
        }
        rs = gain/loss
        rsi = 100 - 100/(1+rs)
        
        if rsi > 70{
            return "Red"
        }else if rsi < 30 {
            return "Green"
        }else{
            return "Gray"
        }
    }
    
    func calculateADX(ts:[Float]) -> String {
// Actually here is SMA indicators
        
        if ts.count < 21 {
            return "Gray"
        }
        var ma:Float = 0.0
        var ma1:Float = 0.0
        for i in 0...19 {
            ma = ma + ts[i]/20
        }
        for i in 1...20 {
            ma1 = ma1 + ts[i]/20.0
        }
        
        if ts[0]>ts[1] && ma>ma1 && ts[0] > ma {
            return "Green"
        }else if ma < ma1 && ts[0] < ma && ts[0]<ts[1] {
            return "Red"
        }else{
            return "Gray"
        }
       
    }
    
    func calculateBB(cts:[Float],hts:[Float],lts:[Float]) -> String {
        
        if cts.count < 20 {
            return "Gray"
        }
        
        var std:Double = 0.0
        var ma:Double = 0.0
        for i in 0...19{
            ma = ma + Double(cts[i])/20.0
        }
        
        for i in 0...19 {
            std = std + (Double(cts[i])-ma)*(Double(cts[i])-ma)
        }
        std = sqrt(std / 19.0)
      //  print(std)
      //  print(ma)
       // print(ma-2*std)
      //  print(lts[0])
     //   print(lts[1])
        if Double(hts[0]) > (ma + std*2) || Double(hts[1]) > (ma +  std*2){
            return "Red"
        }else if Double(lts[0]) < (ma - std*2) || Double(lts[1]) < (ma -  std*2){
            return "Green"
        }else{
            return "Gray"
        }
       
    }
    
    
    func calculateStoch(cts:[Float],hts:[Float],lts:[Float]) -> String {
        if cts.count < 12{
            return "Gray"
        }
        var K:Float = 0.0
        var D:Float = 0.0
        
        for i in 0...2{
            var l:Float = lts[i]
            var h:Float = hts[i]
            
            for j in 0...8{
                if lts[i+j]<l{
                    l = lts[i+j]
                }
                if hts[i+j]>h{
                    h = hts[i+j]
                }
            }
            
            K = (cts[i] - l)/(h-l)*100
            D = D + K/3.0
                
        }
        
      //  print(D)
        if D > 75 {
            return "Red"
        }else if D < 25 {
            return "Green"
        }else{
            return "Gray"
        }
    }
}


