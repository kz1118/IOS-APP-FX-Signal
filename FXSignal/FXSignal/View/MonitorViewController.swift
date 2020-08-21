//
//  ViewController.swift
//  FXSignal
//
//  Created by Lisa on 8/17/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit

class MonitorViewController: UIViewController {

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
    
    @IBOutlet weak var temptest: UILabel!
    
    @IBOutlet weak var macd15mView: UIView!
    @IBOutlet weak var temptestview: UIView!
    
    var indicators:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  //      setStaticFormat(l: [mBlankLabel,m15mLabel,m30mLabel,m1hLabel,m4hLabel,mDLabel,mMLabel,mBLabel,mRLabel,mSLabel,mALabel])

        let indicatorM = IndicatorManager()
        indicatorM.calculateAll()
        indicators = indicatorM.fetchAllIndicator()
        let ls:[UILabel] = [macd15mLabel,macd30mLabel,macd1hLabel,macd4hLabel,macdDLabel,bb15mLabel,bb30mLabel,bb1hLabel,bb4hLabel,bbDLabel,rsi15mLabel,rsi30mLabel,rsi1hLabel,rsi4hLabel,rsiDLabel,stoch15mLabel,stoch30mLabel,stoch1hLabel,stoch4hLabel,stochDLabel,adx15mLabel,adx30mLabel,adx1hLabel,adx4hLabel,adxDLabel]

        for i in 0...(ls.count-1) {
//            setGradientColor(l: ls[i], c: indicators[i])
        }
        
        setGradientColor(l: macd15mView, c: "Red")
        setGradientColor(l: temptestview, c: "Red")
        print(temptestview.bounds)
    }

    
}

