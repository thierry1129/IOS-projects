//
//  ViewController.swift
//  newShop
//
//  Created by Terry Lyu on 1/27/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var originalPrice: UITextField!
    
    @IBOutlet weak var discountRate: UITextField!
    
    @IBOutlet weak var taxRate: UITextField!
    
    @IBOutlet weak var finalPrice: UITextField!
    
    @IBOutlet weak var productName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func amazonTouched(_ sender: Any) {
        let name = productName.text
        
        let newString = name!.replacingOccurrences(of: " ", with: "%20")

            if let url = NSURL(string: "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=\(newString)"){ UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) }
        
    }
    
    @IBAction func walmartTouched(_ sender: Any) {
        
        
        let name = productName.text
        //let aString = "This is my string"
        let newString = name!.replacingOccurrences(of: " ", with: "%20")
        
        
        if let url = NSURL(string: "https://www.walmart.com/search/?query=\(newString)"){ UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) }
        
        
        
    }
  
    @IBAction func targetTouched(_ sender: Any) {
        
        let name = productName.text
        
        let newString = name!.replacingOccurrences(of: " ", with: "%20")

        
        if let url = NSURL(string: "http://www.target.com/s?searchTerm=\(newString)"){ UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) }
        

        
    }
    @IBAction func valChanged(_ sender: UITextField) {
        
        let origin = Double(originalPrice.text!)
       
        
        let discount = Double (discountRate.text!)
        
        
        
        
        let tax = Double (taxRate.text!)
        
        
        
        if (origin != nil && discount != nil && tax != nil && tax!>=0.0 && discount!>=0.0 && origin!>=0.0){
        
            let final = (origin!) *  ( (100-(discount!))/100.0)
            let final2 = (final ) * ((100+(tax! ))/100.0)
            let displayText = "$\(String(format: "%.2f", final2))"
            
            finalPrice.text = String(displayText)
        }
            
        else {
            
            
            
          
                       if ( origin != nil && discount != nil && tax != nil && (tax!<0.0 || discount!<0.0||origin!<0.0)){
                // learnt this from ioscreator.net
                let alertController = UIAlertController(title: "Error", message:
                    "please enter positive value ", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
                       else if ((origin == nil || discount == nil || tax == nil ) && (originalPrice.text != "" && discountRate.text != "" && taxRate.text != "" ))
                       {
                        
                        let alertController = UIAlertController(title: "Error", message:
                            "please enter a valid number ", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        

                        
            }
            
                       else {
                      
            
            }
                  
                        
                        
                        
                        
            }
            
           
        }
        
        
        
    }




