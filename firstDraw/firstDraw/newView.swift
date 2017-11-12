//
//  newView.swift
//  firstDraw
//
//  Created by Terry Lyu on 2/9/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit

class newView: UIView {
    var lineSz: [Int] = []
    
    
    
    var rgb = RGB(red : 0 , green: 0 , blue: 0 )
    var lastPoint: CGPoint!
    var penColor = UIColor.black
    var lines:[Line ] = []
    var context = UIGraphicsGetCurrentContext()
    var prevColor = UIColor.black
    
    
     var prevLines:[Line ] = []
    
    var penThick = CGFloat(1)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        lastPoint = (touches.first)!.location(in: self) as CGPoint
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = (touches.first)!.location(in: self) as CGPoint
        
        lines.append(Line(startPoint: lastPoint, endPoint: newPoint, startColor:penColor, startThick:penThick))
        
        
        
        lastPoint = newPoint
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = (touches.first)!.location(in: self) as CGPoint
        
        lines.append(Line(startPoint: lastPoint, endPoint: newPoint, startColor:penColor , startThick:penThick))
        
        
        lineSz.append(lines.count)
        
        
        
        lastPoint = newPoint
        self.setNeedsDisplay()
    }
    
    
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        
        let context = UIGraphicsGetCurrentContext()
        context!.beginPath()
        
        context?.setLineCap(CGLineCap.round)
        
        for line in lines{
            
            context?.move(to: CGPoint(x:line.start.x, y: line.start.y))
            
            var a = CGPoint (x:0, y:0)
            a.x = line.end.x
            a.y = line.end.y
            context?.addLine( to: a)
            
         //   _ = UIColor.blue.cgColor
            
            
            context?.setLineWidth(line.thick)
            line.color.setStroke()
            
            
            
            context?.strokePath()
            
        }
    }
    
    
}

