//
//  SettingViewController.swift
//  firstDraw
//
//  Created by Terry Lyu on 2/10/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit

/*
 protocol SettingsVCDelegate:class {
 func settingsViewControllerDidFinish(_ settingsVC:SettingViewController)
 }
 */
class SettingViewController: UIViewController, UINavigationControllerDelegate {
  
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    var rgb = RGB(red : 0 , green: 0 , blue: 0 )
    @IBOutlet weak var lb: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        redSlider.setValue(rgb.r, animated:false)
        blueSlider.setValue(rgb.b, animated: false)
        greenSlider.setValue(rgb.g, animated: false)
        
        
        
        
           }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let redFloat = CGFloat(redSlider.value)
        let greenFloat = CGFloat(greenSlider.value)
        let blueFloat = CGFloat(blueSlider.value)
        
        
        if let controller = viewController as? ViewController
        {
            controller.newView.penColor =  UIColor.init(red:  redFloat, green:greenFloat, blue: blueFloat, alpha: 1)
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newToMain"{
            
            let destination0 = segue.destination as! ViewController
            print ("executed")
                       let destination =   destination0.newView
            let redFloat = CGFloat(redSlider.value)
            let greenFloat = CGFloat(greenSlider.value)
            let blueFloat = CGFloat(blueSlider.value)
            
            
            destination?.rgb.r = redSlider.value
            destination?.rgb.b = blueSlider.value
            destination?.rgb.g = greenSlider.value
            destination?.penColor = UIColor.init(red:  redFloat, green:greenFloat, blue: blueFloat, alpha: 1)
            
            
        }
        
        
        
    }
    
}
