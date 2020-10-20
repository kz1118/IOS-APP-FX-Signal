//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 10/14/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation
import Firebase

struct signal {
    var time:String = ""
    var topic:String = ""
    var title:String = ""
    var body:String = ""
    var pnl:Double = 0.0
}

protocol signalManagerDelegate {
    func didReceiveSignalUpdate()
}

class signalManager {
    var signals:[signal] = []
    let ref = Database.database().reference()
    
    var delegate:signalManagerDelegate?
    
    func getAllSignals(){
        
    }
    
    func listenToSignalsUpdate(){
        let postRef = ref.child("signals")
        
        let refHandle = postRef.observe(DataEventType.value , with: { (DataSnapshot) in
            let postDict = DataSnapshot.value as? [String:Any] ?? [:]
            var ordered = postDict.sorted(by: {$0.key > $1.key})
            
            var count = K.numberOfSignals
            if ordered.count < K.numberOfSignals {
                count = ordered.count
            }
            
            self.signals = []
            
            for i in 0..<count {
                var s = signal()
                s.time = (ordered[i].value as! NSDictionary) ["time"] as! String
                s.topic = (ordered[i].value as! NSDictionary) ["topic"] as! String
                s.title = (ordered[i].value as! NSDictionary) ["title"] as! String
                s.body = (ordered[i].value as! NSDictionary) ["body"] as! String
                s.pnl = (ordered[i].value as! NSDictionary) ["pnl"] as! Double
                self.signals.append(s)
            }
    
            self.delegate?.didReceiveSignalUpdate()
        })
        

        
    }
}
