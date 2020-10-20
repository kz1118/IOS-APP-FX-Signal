//
//  StrategyConfigurationManager.swift
//  FXSignal
//
//  Created by Lisa on 8/27/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation
import UIKit

struct Strategy:Codable{
    var currency:String = ""
    var buySell:String = ""
    var threshold:Int = 1000
    var ind1:Indicator = Indicator()
    var ind2:Indicator = Indicator()
    var ind3:Indicator = Indicator()
    var ind4:Indicator = Indicator()
    var ind5:Indicator = Indicator()
}

struct Indicator:Codable {
    var name:String = ""
    var weight: Int = 0
}


class SConfigManager{
    
    var strategy:Strategy = Strategy()
    var strategies:[Strategy] = []
    
    func getCurrencyandBuySell(l:UILabel){
        let t = l.text!
        strategy.currency = String(t.prefix(6))
        let start = t.index(t.startIndex, offsetBy: 7)
        let end = t.index(t.endIndex, offsetBy: 0)
        let range = start..<end
        strategy.buySell = String(t[range])
    }
    
    func getListofIndicator(b:[UIButton]){
        strategy.ind1.name = K.ButtonToIndicatorMapping[b[0].currentTitle!]!
        strategy.ind2.name = K.ButtonToIndicatorMapping[b[1].currentTitle!]!
        strategy.ind3.name = K.ButtonToIndicatorMapping[b[2].currentTitle!]!
        strategy.ind4.name = K.ButtonToIndicatorMapping[b[3].currentTitle!]!
        strategy.ind5.name = K.ButtonToIndicatorMapping[b[4].currentTitle!]!
    }
    
    func getListofWeight(l:[UILabel]){
        strategy.ind1.weight = Int(l[0].text!)!
        strategy.ind2.weight = Int(l[1].text!)!
        strategy.ind3.weight = Int(l[2].text!)!
        strategy.ind4.weight = Int(l[3].text!)!
        strategy.ind5.weight = Int(l[4].text!)!
    }
    
    func getThreshold(t:UITextField){
        if let x = Int(t.text!) {
            strategy.threshold = x
        }else{
            strategy.threshold = 999
        }
    }
    
    func setConfigValue(b:[UIButton],l:[UILabel],t:UITextField,s:[UISlider]){
        for i in strategies{

            if (i.buySell == strategy.buySell && i.currency == strategy.currency){
 
                t.text = String( i.threshold )
                
                l[0].text = String (i.ind1.weight)
                l[1].text = String (i.ind2.weight)
                l[2].text = String (i.ind3.weight)
                l[3].text = String (i.ind4.weight)
                l[4].text = String (i.ind5.weight)
                
                s[0].value = Float(i.ind1.weight)
                s[1].value = Float(i.ind2.weight)
                s[2].value = Float(i.ind3.weight)
                s[3].value = Float(i.ind4.weight)
                s[4].value = Float(i.ind5.weight)
                
                
                for (key, value) in K.ButtonToIndicatorMapping{
                    if value == i.ind1.name{
                        b[0].setTitle(key, for: .normal)
                    }
                    if value == i.ind2.name{
                        b[1].setTitle(key, for: .normal)
                    }
                    if value == i.ind3.name{
                        b[2].setTitle(key, for: .normal)
                    }
                    if value == i.ind4.name{
                        b[3].setTitle(key, for: .normal)
                    }
                    if value == i.ind5.name{
                        b[4].setTitle(key, for: .normal)
                    }
                }
            }
        }
    }
    
    func saveToDefault(){
        
        strategies = strategies.filter{$0.currency != strategy.currency || $0.buySell != strategy.buySell}
        
        strategies.append(strategy)
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(strategies)
            try data.write(to:K.dataFilePath!)
        }catch{
            print("Error happened")
        }
        
     //   print(strategies)
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

}
