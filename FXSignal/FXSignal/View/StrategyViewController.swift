//
//  StrategyViewController.swift
//  FXSignal
//
//  Created by Lisa on 9/8/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit

class StrategyViewController: UIViewController {

    @IBOutlet weak var StrategyTable: UITableView!
    
    var strats:StrategySubscriptionManager = StrategySubscriptionManager()
    
    var currentSelection:Int = 0
    var upperBound:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        StrategyTable.dataSource = self
        StrategyTable.delegate = self
        
        strats.loadSubscribedStrats()
        strats.subscribeAndListen()
        
        print(StrategySubscriptionManager.upperBound)


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let SSController = segue.destination as! StrategySubController
        SSController.sVController = self
        SSController.sID = currentSelection
    }

}

extension StrategyViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strats.strategies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StrategyTable.dequeueReusableCell(withIdentifier: K.strategyCellIdentifier, for: indexPath)
        cell.textLabel?.text = (strats.strategies[indexPath.row]["Description"] as! String)
        cell.textLabel?.numberOfLines = 2
        
        cell.accessoryType = UITableViewCell.AccessoryType(rawValue: 0)!
        if strats.subscribedStrats.contains((strats.strategies[indexPath.row]["Index"] as! String)) {
            cell.accessoryType = UITableViewCell.AccessoryType(rawValue: 3)!
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
}

extension StrategyViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        currentSelection = indexPath.row
        self.performSegue(withIdentifier: "goToSubscription", sender: self)
        
        
    }
}
