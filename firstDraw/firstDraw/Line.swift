//
//  Line.swift
//  firstDraw
//
//  Created by Terry Lyu on 2/9/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit

class Line {
    
    var start: CGPoint
    var end : CGPoint
    var thick : CGFloat
    
    var color: UIColor
    init(startPoint:CGPoint, endPoint: CGPoint, startColor: UIColor, startThick : CGFloat){
        
        color = startColor
        thick = startThick
        start = startPoint
        end = endPoint
        
    }
    
    
    
}
