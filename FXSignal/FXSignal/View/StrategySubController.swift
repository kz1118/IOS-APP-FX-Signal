//
//  StrategySubController.swift
//  FXSignal
//
//  Created by Lisa on 9/9/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit

class StrategySubController: UIViewController {
    
    var sVController:StrategyViewController!
    var sID:Int!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
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
    @IBOutlet weak var ReturnOnInitialCapital: UILabel!
    @IBOutlet weak var AnnualizedReturn: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLabelValue()

    }
    
    func setLabelValue(){
        DescriptionLabel.text = (sVController.strats.strategies[sID]["Description"] as! String)
        InitialInvestment.text = "$" + String(sVController.strats.strategies[sID]["Initial Investment"] as! Int)
        TradingPeriod.text = (sVController.strats.strategies[sID]["Trading Period"] as! String)
        TotalNetProfit.text = "$" + String(sVController.strats.strategies[sID]["Total Net Profit"] as! Double)
        GrossProfit.text = "$" + String(sVController.strats.strategies[sID]["Gross Profit"] as! Double)
        GrossLoss.text = "($" + String(sVController.strats.strategies[sID]["Gross Loss"] as! Double) + ")"
        ProfitFactor.text = String(sVController.strats.strategies[sID]["Profit Factor"] as! Double)
        TotalTrades.text = String(sVController.strats.strategies[sID]["Total Number of Trades"] as! Int)
        WinningTrades.text = String(sVController.strats.strategies[sID]["Winning Trades"] as! Int)
        LosingTrades.text = String(sVController.strats.strategies[sID]["Losing Trades"] as! Int)
        AvgTradeNetProfit.text = "$" + String(sVController.strats.strategies[sID]["Avg. Trade Net Profit"] as! Double)
        ReturnOnInitialCapital.text = String(sVController.strats.strategies[sID]["Return on Initial Capital"] as! Double) + "%"
        AnnualizedReturn.text = String(sVController.strats.strategies[sID]["Annualized Return"] as! Double) + "%"
        
        
    }
    
    @IBAction func subscribePressed(_ sender: Any) {
        print("clicked")
        let result = sVController.strats.toSubscribe(id: sID)
        
        if result == false {
            let alert = UIAlertController(title: "INFORMATION", message: K.reachUpperBoundMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            sVController.StrategyTable.reloadData()
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func unsubscribePressed(_ sender: Any) {
        print("unclicked")

        sVController.strats.toUnsubscribe(id:sID)
        
        sVController.StrategyTable.reloadData()
        
        self.dismiss(animated: true, completion: nil)
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
