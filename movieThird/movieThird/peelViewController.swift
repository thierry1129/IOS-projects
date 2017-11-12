//
//  peelViewController.swift
//  
//
//  Created by Terry Lyu on 3/1/17.
//
//

import UIKit

class peelViewController: UIViewController {

    @IBOutlet weak var plotText = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
           plotText?.text = "no plot stored in the data base "
        // Do any additional setup after loading the view.
    }
    

    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupText (text:String){
        
        plotText?.text = text
        
        
    }
   
  

}
