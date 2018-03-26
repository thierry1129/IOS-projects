//
//  peekViewController.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/23/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit

class peekViewController: UIViewController {

    @IBOutlet weak var peekText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
peekText.text = "No description for this event yet"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupText (text:String){
        
        peekText?.text = text
        
        
    }

}
