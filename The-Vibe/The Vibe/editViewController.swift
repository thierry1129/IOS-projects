//
//  editViewController.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/22/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase


class editViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, DataBackDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var attendeeField: UITextView!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var pickLocationButton: UIButton!
    @IBOutlet weak var pickTimeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    
    var alertController: UIAlertController?
    var datePicker: UIDatePicker!
    var cancelButton: UIButton!
    var pickerSubmitButton: UIButton!
    
    var theRandomID : String = ""
    var eTitle : String = ""
    var eOrganizer : String = ""
    var theEvent : Activities = Activities()
    var clLocation: CLLocationCoordinate2D?
    
    var activityDic : Dictionary<String, Activities> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        attendeeField.delegate = self
        descriptionField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpDatePicker()
        ref = FIRDatabase.database().reference()
        fetchActivities()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.titleField.resignFirstResponder()
        self.attendeeField.resignFirstResponder()
        self.descriptionField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func saveData(chosedLocation: CLLocationCoordinate2D?) {
        print("Saved location data")
        self.clLocation = chosedLocation
        setUpLabels()
    }
    
    @IBAction func pickTypeButtonPressed(_ sender: UIButton) {
        //adapted from http://stackoverflow.com/questions/38042028/how-to-add-actions-to-uialertcontroller-and-get-result-of-actions-swift
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
        theEvent.type = stringToActivityType(str: action.title!)
        typeLabel.text = action.title
    }

    @IBAction func pickTimeButtonPressed(_ sender: UIButton) {
        presentDatePicker()
    }
    
    func presentDatePicker() {
        self.view.addSubview(datePicker)
        self.view.addSubview(pickerSubmitButton)
        self.view.addSubview(cancelButton)
    }
    
    func submitDatePicker() {
        theEvent.startTime = datePicker.date
        timeLabel.text = dateToString(date: datePicker.date)
        cancelDatePicker()
    }
    
    func cancelDatePicker() {
        datePicker.removeFromSuperview()
        pickerSubmitButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
    func dateDidChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }

    @IBAction func submitPressed(_ sender: Any) {
        
     
            print ("editing right now ")
            
            if (titleField.text != nil){
                theEvent.title = titleField.text!
                theEvent.organizer = (FIRAuth.auth()!.currentUser!.email)!
                
                if let description = descriptionField.text {
                    theEvent.description = description
                }
                
                if let location = clLocation {
                    theEvent.location = location
                }
                
                if (isValidActivity(theActivity: theEvent)) {
                    print("Adding to database")
                    self.ref?.child("Activities").child(theRandomID).setValue(formatActivityData(theActivity: theEvent)) { (error, ref) in
                        print("success adding event !!!!!!!!!!!")
                        if error == nil {
                            let alertController = UIAlertController(title: "Success", message: "You have successfully edited this event!", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                                _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else {
                            self.showAlert(title: "Oops", msg: "Failed to update changed to databse")
                        }
                        
                    }
                }
                else {
                    self.showAlert(title: "Oops", msg: "At least one of the input fields is NOT valid")
                }
            }
    }

    func fetchActivities() {
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            
            if let dic = snapshot.value! as? NSDictionary {
                print("currently fetching activities in detailed view")
                
                for (eid, eDetail) in dic {
                    
                    let eventID = eid as! String
                    let dicAct = eDetail as! NSDictionary
                    let activityFetched = Activities()
                    activityFetched.description = dicAct["description"]! as! String
                    activityFetched.title = dicAct["title"]! as! String
                    activityFetched.organizer = dicAct["organizer"]! as! String
                    activityFetched.startTime = stringToDate(dateString: dicAct["time"]! as! String)
                    if let long = dicAct["longitude"] as? String {
                        if let lat = dicAct["latitude"] as? String {
                            let longitude = CLLocationDegrees(exactly: (long as NSString).floatValue)
                            let latitude = CLLocationDegrees(exactly: (lat as NSString).floatValue)
                            activityFetched.location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                        }
                    }
                    activityFetched.type = stringToActivityType(str: dicAct["type"] as! String)
                    
                    if let attendeeOnline = dicAct["attendee"] {
                        
                        print(attendeeOnline)
                        activityFetched.attendee = attendeeOnline as! [String]
                        
                    }
                    self.activityDic[eventID] = activityFetched
                    
                    if (activityFetched.organizer==self.eOrganizer && activityFetched.title==self.eTitle ){
                        self.theRandomID = eventID
                    }
                }
                
                for event in self.activityDic.values {
                    if (event.organizer == self.eOrganizer && event.title == self.eTitle){
                        self.theEvent = event
                        _ = self.theEvent.attendee
                        
                    }
                    
                }

            }
                self.setUpLabels()
        })
        
    }
    
    func setUpLabels() {
        self.titleField.text = self.theEvent.title
        self.typeLabel.text = activityTypeToString(at: self.theEvent.type)
        
        self.descriptionField.text = self.theEvent.description
        self.timeLabel.text = dateToString(date: self.theEvent.startTime)
        if (theEvent.attendee.count == 0) {
            self.attendeeField.text = "There is currently no people registered"
        } else {
            self.attendeeField.text = formatAttendeeText(attendees: theEvent.attendee)
        }
        locationLabel.text = cllocationToStringWithTrim(location: theEvent.location)
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
    
    func showAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
