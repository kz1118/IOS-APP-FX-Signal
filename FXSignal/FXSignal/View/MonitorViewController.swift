//
//  ViewController.swift
//  FXSignal
//
//  Created by Lisa on 8/17/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit
import DropDown

class MonitorViewController: UIViewController, IndicatorManagerDelegate {

    @IBOutlet weak var mBlankLabel: UILabel!
    @IBOutlet weak var m15mLabel: UILabel!
    @IBOutlet weak var m30mLabel: UILabel!
    @IBOutlet weak var m1hLabel: UILabel!
    @IBOutlet weak var m4hLabel: UILabel!
    @IBOutlet weak var mDLabel: UILabel!
    @IBOutlet weak var mMLabel: UILabel!
    @IBOutlet weak var mBLabel: UILabel!
    @IBOutlet weak var mRLabel: UILabel!
    @IBOutlet weak var mSLabel: UILabel!
    @IBOutlet weak var mALabel: UILabel!
    
    @IBOutlet weak var macd15mLabel: UILabel!
    @IBOutlet weak var macd30mLabel: UILabel!
    @IBOutlet weak var macd1hLabel: UILabel!
    @IBOutlet weak var macd4hLabel: UILabel!
    @IBOutlet weak var macdDLabel: UILabel!
    @IBOutlet weak var bb15mLabel: UILabel!
    @IBOutlet weak var bb30mLabel: UILabel!
    @IBOutlet weak var bb1hLabel: UILabel!
    @IBOutlet weak var bb4hLabel: UILabel!
    @IBOutlet weak var bbDLabel: UILabel!
    @IBOutlet weak var rsi15mLabel: UILabel!
    @IBOutlet weak var rsi30mLabel: UILabel!
    @IBOutlet weak var rsi1hLabel: UILabel!
    @IBOutlet weak var rsi4hLabel: UILabel!
    @IBOutlet weak var rsiDLabel: UILabel!
    @IBOutlet weak var stoch15mLabel: UILabel!
    @IBOutlet weak var stoch30mLabel: UILabel!
    @IBOutlet weak var stoch1hLabel: UILabel!
    @IBOutlet weak var stoch4hLabel: UILabel!
    @IBOutlet weak var stochDLabel: UILabel!
    @IBOutlet weak var adx15mLabel: UILabel!
    @IBOutlet weak var adx30mLabel: UILabel!
    @IBOutlet weak var adx1hLabel: UILabel!
    @IBOutlet weak var adx4hLabel: UILabel!
    @IBOutlet weak var adxDLabel: UILabel!
        
    @IBOutlet weak var macd15mView: UIView!
    @IBOutlet weak var macd30mView: UIView!
    @IBOutlet weak var macd1hView: UIView!
    @IBOutlet weak var macd4hView: UIView!
    @IBOutlet weak var macdDView: UIView!
    @IBOutlet weak var bb15mView: UIView!
    @IBOutlet weak var bb30mView: UIView!
    @IBOutlet weak var bb1hView: UIView!
    @IBOutlet weak var bb4hView: UIView!
    @IBOutlet weak var bbDView: UIView!
    @IBOutlet weak var rsi15mView: UIView!
    @IBOutlet weak var rsi30mView: UIView!
    @IBOutlet weak var rsi1hView: UIView!
    @IBOutlet weak var rsi4hView: UIView!
    @IBOutlet weak var rsiDView: UIView!
    @IBOutlet weak var stoch15mView: UIView!
    @IBOutlet weak var stoch30mView: UIView!
    @IBOutlet weak var stoch1hView: UIView!
    @IBOutlet weak var stoch4hView: UIView!
    @IBOutlet weak var stochDView: UIView!
    @IBOutlet weak var adx15mView: UIView!
    @IBOutlet weak var adx30mView: UIView!
    @IBOutlet weak var adx1hView: UIView!
    @IBOutlet weak var adx4hView: UIView!
    @IBOutlet weak var adxDView: UIView!
    
    @IBOutlet weak var SelectorView: UIView!
    @IBOutlet weak var SelectorButton: UIButton!
    
    
    var indicators:[String] = []
    var currentFxRates: Float = 1.0
    var previousFXRates: Float = 1.0
    var fxColor: String = "Gray"
    var lastUpdate: String = ""
    
    @IBOutlet weak var fxRateLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    @IBOutlet weak var blinkBuyIndicator: UILabel!
    @IBOutlet weak var blinkSellIndicator: UILabel!
    @IBOutlet weak var buyCustomizeButton: UIButton!
    @IBOutlet weak var sellCustomizeButton: UIButton!
    
    var indicatorM = IndicatorManager(c:"EURUSD")
    var MSController = MonitorSetupController()
    
    var blinkStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        indicatorM.delegate = self
        
        setMonitorStaticFormat(l: [mBlankLabel,m15mLabel,m30mLabel,m1hLabel,m4hLabel,mDLabel,mMLabel,mBLabel,mRLabel,mSLabel,mALabel])
        setMonitorStaticFormat(l: [macd15mView,macd30mView,macd1hView,macd4hView,macdDView,bb15mView,bb30mView,bb1hView,bb4hView,bbDView,rsi15mView,rsi30mView,rsi1hView,rsi4hView,rsiDView])
        setMonitorStaticFormat(l: [stoch15mView,stoch30mView,stoch1hView,stoch4hView,stochDView,adx15mView,adx30mView,adx1hView,adx4hView,adxDView])
        setMonitorStaticFormat(l: [buyCustomizeButton,sellCustomizeButton])
        setCurrencySelectorButtonFormat(l:SelectorButton)
        
        indicatorM.loadDefault()
        
        indicatorM.performRequest()
        
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(labelChangeColor), userInfo: nil, repeats: true)
        

    }
    

    func updateMonitorDashboard(im: IndicatorModel){

  //      indicatorM.calculateAll()
        indicators = im.fetchAllIndicator()
        
        let ls:[UILabel] = [macd15mLabel,macd30mLabel,macd1hLabel,macd4hLabel,macdDLabel,bb15mLabel,bb30mLabel,bb1hLabel,bb4hLabel,bbDLabel,rsi15mLabel,rsi30mLabel,rsi1hLabel,rsi4hLabel,rsiDLabel,stoch15mLabel,stoch30mLabel,stoch1hLabel,stoch4hLabel,stochDLabel,adx15mLabel,adx30mLabel,adx1hLabel,adx4hLabel,adxDLabel]
        
        let vs:[UIView] = [macd15mView,macd30mView,macd1hView,macd4hView,macdDView,bb15mView,bb30mView,bb1hView,bb4hView,bbDView,rsi15mView,rsi30mView,rsi1hView,rsi4hView,rsiDView,stoch15mView,stoch30mView,stoch1hView,stoch4hView,stochDView,adx15mView,adx30mView,adx1hView,adx4hView,adxDView]
        
        for i in 0...(vs.count-1) {
            setGradientColor(l: vs[i], c: indicators[i])
        }
        
        for i in 0...(ls.count-1) {
            setMonitorLabelText(l: ls[i], c: indicators[i])
        }
        
    }
    
    func updateRateLine(im: IndicatorModel){
        lastUpdate = im.lastRefreshed
        currentFxRates = im.closeTs[im.closeTs.count-1]
        previousFXRates = im.closeTs[im.closeTs.count-2]
        fxRateLabel.text = String(currentFxRates)
        updateTimeLabel.text = lastUpdate + " UTC"
    }
    
    func updateBuySellLabel(im:IndicatorModel){
        blinkBuyIndicator.text = im.buySignal
        blinkSellIndicator.text = im.sellSignal
        setBuyLabelTextColor(l:blinkBuyIndicator)
        setSellLabelTextColor(l:blinkSellIndicator)
    }
    
    @IBAction func CurrencySelected(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = SelectorView
        dropDown.dataSource = K.CurrencyPairs
 //       dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.SelectorButton.setTitle(item, for: .normal)
            self.indicatorM.setCurrency(c: item)
            self.indicatorM.performRequest()
            
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToBuySetup", sender: self)
    }
    @IBAction func sellButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSellSetup", sender: self)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let MSController = segue.destination as! MonitorSetupController
        MSController.currency = indicatorM.im.currency
        MSController.MVController = self
        if(segue.identifier == "goToBuySetup"){
            MSController.buySell = "BUY"
        }else if (segue.identifier == "goToSellSetup"){
            MSController.buySell = "SELL"
        }
    }
    
    
    func didUpdateIndicators(im: IndicatorModel) {
        DispatchQueue.main.async {
            self.updateMonitorDashboard(im:im)
            self.updateRateLine(im: im)
            self.updateBuySellLabel(im:im)
        }
    }
    
    func reloadData()   {
        indicatorM.delegate = self
        indicatorM.loadDefault()
        print(indicatorM.im.currency)
        indicatorM.performRequest()
    }
    

    @IBAction func RefreshButtonPressed(_ sender: UIButton) {
        indicatorM.loadDefault()
        indicatorM.performRequest()
    }
    
    @objc func labelChangeColor(){
        if (blinkStatus == false){
            blinkBuyIndicator.backgroundColor = UIColor.gray
            blinkSellIndicator.backgroundColor = UIColor.gray
            blinkStatus = true
        }else{
            blinkBuyIndicator.backgroundColor = UIColor.lightGray
            blinkSellIndicator.backgroundColor = UIColor.lightGray
            blinkStatus = false
        }
    }
}

