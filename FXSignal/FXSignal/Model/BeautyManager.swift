//
//  File.swift
//  FXSignal
//
//  Created by Lisa on 8/20/20.
//  Copyright © 2020 Lisa Liu. All rights reserved.
//

import Foundation
import UIKit



class Colors {
    var gl:CAGradientLayer!
    
    init(rt:CGFloat, gt:CGFloat, bt:CGFloat, rb:CGFloat, gb:CGFloat, bb:CGFloat){
        let colorTop = UIColor(red: rt, green: gt, blue: bt, alpha:1.0).cgColor
        let colorBottom = UIColor(red: rb, green: gb, blue: bb, alpha:1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop,colorBottom]
        self.gl.locations = [0.0,1.0]
    }
}
    


func setGradientColor(l:UIView,c:String){
    var colors=Colors(rt:K.GrayColor.topRed,gt:K.GrayColor.topGreen,bt:K.GrayColor.topBlue,rb:K.GrayColor.bottomRed,gb:K.GrayColor.bottomGreen,bb:K.GrayColor.bottomBlue)
    switch c {
    case "Red":
        colors=Colors(rt:K.RedColor.topRed,gt:K.RedColor.topGreen,bt:K.RedColor.topBlue,rb:K.RedColor.bottomRed,gb:K.RedColor.bottomGreen,bb:K.RedColor.bottomBlue)
    case "Green":
        colors=Colors(rt:K.GreenColor.topRed,gt:K.GreenColor.topGreen,bt:K.GreenColor.topBlue,rb:K.GreenColor.bottomRed,gb:K.GreenColor.bottomGreen,bb:K.GreenColor.bottomBlue)
    case "Gray":
        colors=Colors(rt:K.GrayColor.topRed,gt:K.GrayColor.topGreen,bt:K.GrayColor.topBlue,rb:K.GrayColor.bottomRed,gb:K.GrayColor.bottomGreen,bb:K.GrayColor.bottomBlue)
    default:
        colors=Colors(rt:K.GrayColor.topRed,gt:K.GrayColor.topGreen,bt:K.GrayColor.topBlue,rb:K.GrayColor.bottomRed,gb:K.GrayColor.bottomGreen,bb:K.GrayColor.bottomBlue)
    }
    
    l.backgroundColor = UIColor.clear
    let backgroundLayer = colors.gl
    backgroundLayer?.frame = l.bounds
    print(l.frame)
    print(l.bounds)
//    print("")
    l.layer.insertSublayer(backgroundLayer!,at:0)
}

func setStaticFormat(l:[UILabel]){
    let labels = l
    
    for i in labels{
        i.layer.masksToBounds = true
        i.layer.cornerRadius = (i.frame.height)/8
    }
}
