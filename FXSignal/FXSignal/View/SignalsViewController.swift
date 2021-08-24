//
//  SignalsViewController.swift
//  FXSignal
//
//  Created by Lisa on 10/14/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit

class SignalsViewController: UIViewController,signalManagerDelegate {
    
    @IBOutlet weak var signalsTable: UITableView!
    
    var SM = signalManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signalsTable.dataSource = self
        SM.delegate = self
        
        signalsTable.register(UINib(nibName: "SignalCell", bundle: nil), forCellReuseIdentifier: "SignalCell")
        
        SM.listenToSignalsUpdate()
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

extension SignalsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return strats.strategies.count
        return SM.signals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = signalsTable.dequeueReusableCell(withIdentifier: K.signalCellIdentifier, for: indexPath) as! SignalCell
        cell.strategyCell.text = SM.signals[indexPath.row].title
        cell.timeCell.text = SM.signals[indexPath.row].time
        cell.bodyCell.text = SM.signals[indexPath.row].body
        
        if SM.signals[indexPath.row].body.contains("Open"){
            cell.cellView.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8862745098, blue: 0.937254902, alpha: 1)
            cell.statusCell.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.6078431373, blue: 0.6431372549, alpha: 1)
            if checkIsLiveSignal(indexPath.row)==true {
                cell.statusCell.textColor = UIColor.yellow
                cell.statusCell.text = "LIVE!"
            }else{
                cell.statusCell.textColor = UIColor.white
                cell.statusCell.text = "Closed"
            }
            if(StrategySubscriptionManager.upperBound==1 && cell.statusCell.text == "LIVE!"){
                cell.bodyCell.text = "Open: SIGNAL LOCKED"
            }
        }else{
            cell.cellView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.8745098039, blue: 0.8352941176, alpha: 1)
            if SM.signals[indexPath.row].pnl > 0 {
                cell.statusCell.backgroundColor = #colorLiteral(red: 0, green: 0.6274509804, blue: 0.007843137255, alpha: 1)
                cell.statusCell.text = "Profit \n" + String(SM.signals[indexPath.row].pnl)
            }else{
                cell.statusCell.backgroundColor = #colorLiteral(red: 0.7843137255, green: 0.2039215686, blue: 0.1803921569, alpha: 1)
                cell.statusCell.text = "Loss \n" + String(SM.signals[indexPath.row].pnl)
            }
        }
        
        return cell
    }
    
    func checkIsLiveSignal(_ row: Int)->Bool{
        if row == 0 {
            return true
        }
        
        for i in 0..<row {
            if SM.signals[i].topic == SM.signals[row].topic {
                return false
            }
        }
        
        return true
    }
    
    func didReceiveSignalUpdate() {
        signalsTable.reloadData()
    }
}
