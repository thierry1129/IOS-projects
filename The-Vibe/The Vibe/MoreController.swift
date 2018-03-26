//
//  MoreController.swift
//  
//
//  Created by Rocomenty on 4/11/17.
//
//

import UIKit
import FirebaseAuth

class MoreController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : getOrange()]
    }
    

    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        try!FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "logOut", sender: self)
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
