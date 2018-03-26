//
//  AddEventController.swift
//  The Vibe
//
//  Created by Rocomenty on 4/11/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit

class AddEventController: UIViewController, DataBackDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    func saveData(chosedLocation: CLLocationCoordinate2D?) {
        print("Saved location data")
        self.clLocation = chosedLocation
        setUpLabels()
    }

    var ref: FIRDatabaseReference?
    var theActivity: Activities?
    
    var datePicker: UIDatePicker!
    var cancelButton: UIButton!
    var pickerSubmitButton: UIButton!
    var clLocation: CLLocationCoordinate2D?
    var alertController: UIAlertController?
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theActivity = Activities() //default init
        setUpDatePicker()
        ref = FIRDatabase.database().reference()
        titleInput.delegate = self
        descriptionInput.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
        setUpLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func dismisskeyboard() {
        self.titleInput.resignFirstResponder()
        self.descriptionInput.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismisskeyboard()
        return true
    }
    
    func setUpLabels() {
        //type
        typeLabel.text = theActivity?.activityToString()
        
        //locations
        if clLocation != nil {
            locationLabel.text = cllocationToStringWithTrim(location: clLocation!)
        }
        else {
            locationLabel.text = "Please Pick a location"
        }
        //time
        startTimeLabel.text = dateToString(date: (theActivity?.startTime)!)
        
        
        
    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        //adapted from http://stackoverflow.com/questions/38042028/how-to-add-actions-to-uialertcontroller-and-get-result-of-actions-swift
        titleInput.resignFirstResponder()
        let alert = UIAlertController(title: "Please pick an event type", message: "", preferredStyle: .actionSheet)
        for i in ["Academic", "Student Organization", "Personal", "Cancel"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: getEventType))
        }
        alertController = alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func getEventType(action: UIAlertAction) {
        if (action.title == "Cancel") {
            alertController?.dismiss(animated: true, completion: nil)
            return
        }
        theActivity?.type = stringToActivityType(str: action.title!)
        typeLabel.text = action.title
    }
    
    @IBAction func pickStartTimePressed(_ sender: UIButton) {
        presentDatePicker()
    }
    
    func presentDatePicker() {
        self.view.addSubview(datePicker)
        self.view.addSubview(pickerSubmitButton)
        self.view.addSubview(cancelButton)
    }
    
    func dateDidChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    func cancelDatePicker() {
        datePicker.removeFromSuperview()
        pickerSubmitButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
    func submitDatePicker() {
        theActivity?.startTime = datePicker.date
        startTimeLabel.text = dateToString(date: datePicker.date)
        cancelDatePicker()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let activity = theActivity {
            print("adding to data")
            if (titleInput.text != nil) {
                theActivity?.title = titleInput.text!
                theActivity?.organizer = (FIRAuth.auth()!.currentUser!.email)!
                if let description = descriptionInput.text {
                    theActivity?.description = description
                }
                else {
                    self.showAddAlert(title: "Note!", msg: "Description (optional) is empty")
                }
                
                if let location = clLocation {
                    theActivity?.location = location
                }
                else {
                    self.showAddAlert(title: "Oops", msg: "Location is Empty")
                    return
                }
                
                if (isValidActivity(theActivity: activity)) {
                    print("Adding to database")
                    self.ref?.child("Activities").childByAutoId().setValue(formatActivityData(theActivity: activity)) { (error, ref) in
                        print("success adding event !!!!!!!!!!!")
                        if error == nil {
                            let alertController = UIAlertController(title: "Success!", message: "You have successfully added an event!", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                self.performSegue(withIdentifier: "addEventToMain", sender: self)
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            self.showAddAlert(title: "Oops", msg: "Error when saving to database")
                        }
                    }
                }
            }
            else {
                self.showAddAlert(title: "Oops", msg: "The title is empty")
            }
        }
    }
    
    func setUpDatePicker() {
        datePicker = UIDatePicker()
        cancelButton = UIButton()
        pickerSubmitButton = UIButton()
        datePicker.frame = CGRect(x: 0, y: 400, width: self.view.frame.width, height: 200)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = self.submitButton.backgroundColor
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.tintColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateDidChanged), for: .valueChanged)
        
        cancelButton.frame = CGRect(x: self.view.frame.maxX-100, y: 350, width: 100, height: 30)
        cancelButton.backgroundColor = self.submitButton.backgroundColor
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelDatePicker), for: .touchUpInside)
        
        pickerSubmitButton.frame = CGRect(x: 0, y: 350, width: 100, height: 30)
        pickerSubmitButton.backgroundColor = self.submitButton.backgroundColor
        pickerSubmitButton.setTitleColor(UIColor.white, for: .normal)
        pickerSubmitButton.setTitle("Submit", for: .normal)
        pickerSubmitButton.addTarget(self, action: #selector(self.submitDatePicker), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPickLocation" {
            if let toVC = segue.destination as? PickLocationController {
                toVC.delegate = self
            }
        }
    }
    
    func showAddAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
