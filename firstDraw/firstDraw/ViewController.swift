//
//  ViewController.swift
//  firstDraw
//
//  Created by Terry Lyu on 2/9/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var newView: newView!
    
    @IBOutlet weak var thickSlider: UISlider!
    
    @IBOutlet weak var myLabel: UILabel!
    var brushView2: UIImageView!
    
    
    @IBOutlet weak var brushView: UIImageView!
    
    var rgb = RGB(red : 0 , green: 0 , blue: 0 )
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newView.penThick = CGFloat(thickSlider.value)

        
    }
    
    
    
    
    @IBAction func sliderValChanged(_ sender: UISlider) {
        
        print(thickSlider.value)
        
        
        newView.penThick = CGFloat(thickSlider.value)
        
    }
    
    
    
    @IBOutlet weak var settingStack: UIStackView!
    
    @IBOutlet weak var functionsButton: UIButton!
    @IBAction func show(_ sender: Any) {
        settingStack.isHidden  = false
        
        
        functionsButton.isHidden = true
    }
    
    @IBAction func backClicked(_ sender: Any) {
        settingStack.isHidden  = true
        
        newView.penColor = newView.prevColor
        functionsButton.isHidden = false
    }
    @IBAction func undoPressed(_ sender: Any) {
        
        let end =  newView.lineSz.last
        print(newView.lineSz)
        var secondEnd = 0
        if (newView.lineSz.count > 1){
            secondEnd = newView.lineSz [newView.lineSz.count-2]
            print("second end is \(secondEnd)")
            print("end is \(end)")
            
            
            print("end2 is \(newView.lines.endIndex)")
            
            let range = newView.lines.index(newView.lines.endIndex, offsetBy: (secondEnd-end!))..<newView.lines.endIndex
            
            
            newView.lines.removeSubrange(range)
            newView.lineSz.removeLast()
            
            
            newView.setNeedsDisplay()
            
        }
        else if newView.lineSz.count == 1 {
            newView.lines = []
            newView.setNeedsDisplay()
            newView.lineSz = []
            
        }
        else {
            let alertController = UIAlertController(title: "Error", message:
                "cannot undo an empty canvas  ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Go back to drawing", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
        
        
    }
    @IBAction func clearClicked(_ sender: Any) {
        
        newView.lines = []
        newView.setNeedsDisplay()
    }
    
    @IBAction func eraseClicked(_ sender: Any) {
        let color = UIColor.white
        newView.prevColor = newView.penColor
        

        newView.penColor = color;
        
        
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alertController = UIAlertController(title: "photo", message:
            "saved ", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Go back to drawing", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func colorChange(_ sender: UIButton) {
        var color : UIColor!
        
        if (sender.titleLabel?.text == "red"){
            
            
            color = UIColor.red
            
            
        }
        else if (sender.titleLabel?.text == "Black" )  {
            
            color = UIColor.black
        }
        else if (sender.titleLabel?.text == "brown"){
            color = UIColor.brown
            
        }
        else if(sender.titleLabel?.text == "yellow"){
            color = UIColor.yellow
        }
        else if (sender.titleLabel?.text == "blue"){
            color = UIColor.blue
            
        }
        newView.penColor = color;
      
    }
    
    /*
    func navigationController(_ navigationController: UINavigationController, didShow SettingViewController: SettingViewController, animated: Bool) {
        
        
        print("executednavmain to set")
        if let controller = SettingViewController as? SettingViewController
        {
            controller.redSlider.value = rgb.r
            controller.blueSlider.value = rgb.b
            controller.greenSlider.value = rgb.g            //
            
            
            controller.redSlider.setValue( rgb.r,animated: false)
            controller.blueSlider.setValue (rgb.b, animated: false)
            
            
            controller.greenSlider.setValue(rgb.g, animated: false)
        }
        
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToNew"{
            
            if let destination0 = segue.destination as? SettingViewController{
                print ("executedmaintosetting   prepare")
                
                    
                        destination0.rgb.g =  Float(newView.penColor.components.green)
                
                destination0.rgb.b =  Float(newView.penColor.components.blue)
                destination0.rgb.r =  Float(newView.penColor.components.red)

                
            }
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

