//
//  LoginController.swift
//  
//
//  Created by Rocomenty on 4/11/17.
//
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        if (FIRAuth.auth()?.currentUser) != nil {
            self.performSegue(withIdentifier: "toMain", sender: self)
        }
        emailField.delegate = self
        pwdField.delegate = self
    }
    
    func dismissKeyboard() {
        emailField.resignFirstResponder()
        pwdField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if (emailField.text == "" || pwdField.text == "") {
            showLoginAlert(title: "Oops", msg: "Please enter both email and password!")
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.pwdField.text!, completion: { (user, error) in
                
                self.handleError(error: error, user: user)
                
            })
        }
    }
    @IBAction func resetPressed(_ sender: Any) {
        
        
        
        
        let email = self.emailField.text!
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                
                let alertController = UIAlertController(title: "Error", message:
                    "reset password, enter a existing email or a valid email format  ", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "go back to reset", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                print(error)
                // An error happened.
            } else {
                print("password reset sent")
                self.showLoginAlert(title: "Success", msg: "A password reset request is sent to your email")
                // Password reset email sent.
            }
        }

    }

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if (emailField.text == "" || pwdField.text == "") {
            showLoginAlert(title: "Oops", msg: "Please enter both email and password!")
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: pwdField.text!, completion: {(user, error) in
                
                self.handleError(error: error, user: user)
                
            })
        }
        
    }
    
    func handleError(error: Error?, user: FIRUser?) {
        
        if error == nil {
            self.emailField.text = ""
            self.pwdField.text = ""
            self.performSegue(withIdentifier: "toMain", sender: self)
        }
        else {
            showLoginAlert(title: "Oops", msg: error!.localizedDescription)
        }
        
    }
    
    func showLoginAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

}
