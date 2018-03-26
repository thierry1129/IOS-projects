//
//  CustomSegue.swift
//  
//
//  Created by Rocomenty on 4/16/17.
//
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        let sourceView = self.source.view
        let destinationView = self.destination.view
        
        let window = UIApplication.shared.delegate?.window
        
        window??.insertSubview(destinationView!, belowSubview: sourceView!)
        
        destinationView?.center = CGPoint(x: (sourceView?.center.x)!, y: (sourceView?.center.y)!)
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        sourceView?.center = CGPoint(x: (sourceView?.center.x)!, y: 0 - 2*(sourceView?.center.y)!)
                       },
                       completion: {
                        (value: Bool) in
                        if (value) {
                            sourceView?.removeFromSuperview();
                        }
        })
    }
    
    
}
