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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DescriptionLabel.text = (sVController.strats.strategies[sID]["Description"] as! String)

    }
    
    @IBAction func subscribePressed(_ sender: Any) {
        print("clicked")
        sVController.strats.toSubscribe(id: sID)

        sVController.StrategyTable.reloadData()

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
