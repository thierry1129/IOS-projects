//
//  detailedViewController.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/20/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
class detailedViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventOrganizer: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    var activityList :[Activities] = []
    var refHandle: UInt!
    var detailedData :NSDictionary = [:]
    var ref: FIRDatabaseReference?
    var eTitle: String = ""
    var eOrganizer:String = ""
    var eTime: String = ""
    var eDescription: String = ""
    var activityDic : Dictionary<String, Activities> = [:]
     var theEvent : Activities = Activities()
    var theRandomId : String = ""
    var theAttendee : [String] = []
    var isRegistered : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitle.text = eTitle
        eventOrganizer.text = eOrganizer
        eventTime.text = eTime
        eventDescription.text = eDescription
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        ref = FIRDatabase.database().reference()
        print("event title is \(eTitle)")
        
        fetchActivities()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        
        if (isRegistered){
         let index =   theEvent.attendee.index(of:  (FIRAuth.auth()?.currentUser?.email)!)
            theEvent.attendee.remove(at: index!)
            self.ref?.child("Activities").child(theRandomId).setValue(formatActivityData(theActivity: theEvent)) { (error, ref) in
                print("success unregistering event !!!!!!!!!!!")
                if error == nil {
                    self.showDetailAlert(title: "Success!", msg: "You have successfully unregistered this event")
                    self.registerButton.setTitle("Register", for: .normal)
                    self.isRegistered = false
                }
                else {
                    self.showDetailAlert(title: "Oops", msg: error!.localizedDescription)
                }
            }
        }
        else{
            theEvent.attendee.append(   (FIRAuth.auth()?.currentUser?.email)!)
                self.ref?.child("Activities").child(theRandomId).setValue(formatActivityData(theActivity: theEvent)) { (error, ref) in
                print("success registering event !!!!!!!!!!!")
                    if error == nil {
                        self.showDetailAlert(title: "Success!", msg: "You have successfully registered this event")
                    }
            }
        }
        
    }
    

    
    func fetchActivities() {
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            
            let dic = snapshot.value! as! NSDictionary
            print("currently fetching activities in detailed view")
            
            for (eid, eDetail) in dic {
                
                let eventID = eid as! String
                let dicAct = eDetail as! NSDictionary
                let activityFetched = Activities()
                activityFetched.description = dicAct["description"]! as! String
                print("the desciption of each event is \(activityFetched.description)")
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
                
                if let attendeeOnline = dicAct["attendee"]{
                    
                    print(attendeeOnline)
                    activityFetched.attendee = attendeeOnline as! [String]
                    
                }
                self.activityDic[eventID] = activityFetched

                if (activityFetched.organizer==self.eOrganizer && activityFetched.title==self.eTitle ){
                    self.theRandomId = eventID
                }
            }
            for event in self.activityDic.values {
                if ( event.organizer == self.eOrganizer && event.title == self.eTitle){
                    self.theEvent = event
                    print(event.location)
                    let attendee = self.theEvent.attendee
                    
                    if (attendee.contains((FIRAuth.auth()?.currentUser?.email)!)){
                        self.registerButton.setTitle("Unregister", for: .normal)
                        self.isRegistered = true
                        
                    }
                }
            }
            self.setUpLabels()

        })
    }
    
    func setUpLabels() {
        self.eventDescription.text = self.theEvent.description
        print(self.theEvent.description)
        self.eventTime.text = dateToString(date: self.theEvent.startTime)
        print(theEvent.location)
        self.eventLocation.text = cllocationToStringWithTrim(location: theEvent.location)
    }
    
    func showDetailAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    
}
