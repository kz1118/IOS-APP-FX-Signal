//
//  MonitorSetupController.swift
//  FXSignal
//
//  Created by Lisa on 8/25/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit
import DropDown

class MonitorSetupController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var indicator1View: UIView!
    @IBOutlet weak var indicator1Button: UIButton!
    @IBOutlet weak var indicator2View: UIView!
    @IBOutlet weak var indicator2Button: UIButton!
    @IBOutlet weak var indicator3View: UIView!
    @IBOutlet weak var indicator3Button: UIButton!
    @IBOutlet weak var indicator4View: UIView!
    @IBOutlet weak var indicator4Button: UIButton!
    @IBOutlet weak var indicator5View: UIView!
    @IBOutlet weak var indicator5Button: UIButton!
    
    @IBOutlet weak var weightSlider1: UISlider!
    @IBOutlet weak var weightSlider2: UISlider!
    @IBOutlet weak var weightSlider3: UISlider!
    @IBOutlet weak var weightSlider4: UISlider!
    @IBOutlet weak var weightSlider5: UISlider!
    @IBOutlet weak var weightLabel1: UILabel!
    @IBOutlet weak var weightLabel2: UILabel!
    @IBOutlet weak var weightLabel3: UILabel!
    @IBOutlet weak var weightLabel4: UILabel!
    @IBOutlet weak var weightLabel5: UILabel!
    
    @IBOutlet weak var threasholdTextField: UITextField!
    
    var scManager = SConfigManager()
 //   var strategies:[Strategy] = []
    
    var MVController:MonitorViewController!
    var currency:String!
    var buySell:String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        threasholdTextField.delegate = self
    
        // Do any additional setup after loading the view.
        updateTitle()
        
        scManager.loadDefault()
        print(scManager.strategies)
        
        scManager.getCurrencyandBuySell(l: currencyLabel)
  
        scManager.setConfigValue(b: [indicator1Button,indicator2Button,indicator3Button,indicator4Button,indicator5Button], l: [weightLabel1,weightLabel2,weightLabel3,weightLabel4,weightLabel5], t: threasholdTextField,s:[weightSlider1,weightSlider2,weightSlider3,weightSlider4,weightSlider5])

    }
    
    func updateTitle(){
        currencyLabel.text = currency + " " + buySell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Indicator1Pressed(_ sender: UIButton) {

        let dropDown = DropDown()
        switch sender.tag {
        case 1:
            dropDown.anchorView = indicator1View
        case 2:
            dropDown.anchorView = indicator2View
        case 3:
            dropDown.anchorView = indicator3View
        case 4:
            dropDown.anchorView = indicator4View
        case 5:
            dropDown.anchorView = indicator5View
        default:
            print("Nothing")
        }
 
        dropDown.dataSource = K.SupportedIndicators
        //dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            switch sender.tag {
            case 1:
                self.indicator1Button.setTitle(item, for: .normal)
            case 2:
                self.indicator2Button.setTitle(item, for: .normal)
            case 3:
                self.indicator3Button.setTitle(item, for: .normal)
            case 4:
                self.indicator4Button.setTitle(item, for: .normal)
            case 5:
                self.indicator5Button.setTitle(item, for: .normal)
            default:
                print("Nothing")
            }
            
        }
    }
    
    @IBAction func indicatorSliderValueChange(_ sender: UISlider) {
        switch sender.tag {
        case 1:
            weightLabel1.text = String(format:"%.0f",sender.value)
        case 2:
            weightLabel2.text = String(format:"%.0f",sender.value)
        case 3:
            weightLabel3.text = String(format:"%.0f",sender.value)
        case 4:
            weightLabel4.text = String(format:"%.0f",sender.value)
        case 5:
            weightLabel5.text = String(format:"%.0f",sender.value)
        default:
            print("nothing")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        threasholdTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let x = Int(textField.text!){
            return true
        }else{
            textField.text = ""
            textField.placeholder = "Input a number (0-500)"
            return false
        }
    }
    
    
    
    @IBAction func textFieldtouchOutside(_ sender: UITextField) {
        sender.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        scManager.getListofIndicator(b:[indicator1Button,indicator2Button,indicator3Button,indicator4Button,indicator5Button])
        scManager.getListofWeight(l: [weightLabel1,weightLabel2,weightLabel3,weightLabel4,weightLabel5])
        scManager.getThreshold(t: threasholdTextField)
//        print(scManager.strategy)
        
        scManager.saveToDefault()
        
        MVController.reloadData()

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ExplainationButtonPressed(_ sender: Any) {

        let alert = UIAlertController(title: "CONFIGURATION INSTRUCTION", message: K.strategyConfigMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
