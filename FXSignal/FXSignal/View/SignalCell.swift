//
//  SignalCell.swift
//  FXSignal
//
//  Created by Lisa on 10/15/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import UIKit

class SignalCell: UITableViewCell {

    @IBOutlet weak var strategyCell: UILabel!
    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var bodyCell: UILabel!
    @IBOutlet weak var statusCell: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        statusCell.clipsToBounds = true
        statusCell.layer.cornerRadius = statusCell.frame.size.height/4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
