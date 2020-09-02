//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 8/21/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation

struct FXData:Codable{
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series FX (15min)"
    }
    let metaData:[String:String]
    let timeSeries:[String:[String:String]]
}
