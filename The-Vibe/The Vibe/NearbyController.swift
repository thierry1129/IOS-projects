//
//  NearbyController.swift
//  The Vibe
//
//  Created by Rocomenty on 4/16/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class NearbyController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    var currentLocation: CLLocation?
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    var firstLoad: Bool = true
    
    var data: [[String]] = [] //index 0 is title, index 1 is organizer
    var locationData: [CLLocation] = []
    
    var eTitle: String?
    var eOrganizer: String?
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        ref = FIRDatabase.database().reference()
        if (currentLocation != nil) {
            fetchActivities()
        }
        firstLoad = true
        setUpNavigationBar()
        self.showNearbyAlert(title: "Yay", msg: "Events within 10km are updated. Press the paper plane button on the bottom right corner to update again. ")

    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : getOrange()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //adapted from https://www.youtube.com/watch?v=wl2kqGixL90
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            currentLocation = loc
            if firstLoad {
                fetchActivities()
                changeMapSize(location: loc)
                firstLoad = false
            }
        }
    }
    
    
    
    //adapted from https://www.youtube.com/watch?v=wl2kqGixL90
    func changeMapSize(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        if let userLocation = mapView.userLocation.location {
            changeMapSize(location: userLocation)
            fetchActivities()
        }
    }
    
    func addPins() {
        mapView.removeAnnotations(mapView.annotations)
        for index in 0 ..< data.count {
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationData[index].coordinate
            annotation.title = data[index][0]
            annotation.subtitle = data[index][1]
            mapView.addAnnotation(annotation)
        }
    }
    
    func fetchActivities() {
        data = []
        locationData = []
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            print("fetching for map")
            let dic = snapshot.value! as! NSDictionary
            let dicValue = dic.allValues as NSArray
            
            for singleActivity in dicValue {
                let activity = singleActivity as! NSDictionary
                if let long = activity["longitude"] as? String {
                    print("in here 1")
                    if let lat = activity["latitude"] as? String {
                        let longitude = CLLocationDegrees(exactly: (long as NSString).floatValue)
                        let latitude = CLLocationDegrees(exactly: (lat as NSString).floatValue)
                        let eventLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                        if (eventLocation.distance(from: self.currentLocation!) < 10000) {
                            print("in here 2")
                            let theTitle = activity["title"] as! String
                            let theOrganizer = activity["organizer"] as! String
                            let dataBit = [theTitle,theOrganizer]
                            self.data.append(dataBit)
                            self.locationData.append(eventLocation)
                        }
                    }

                }
            }
            self.addPins()
            
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        if annotation is MKUserLocation {
            return nil
        } else {
            pinView?.pinTintColor = UIColor.orange
        }
        
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "checkmark.png"), for: .normal)
        pinView?.rightCalloutAccessoryView = button
        eTitle = annotation.title!
        eOrganizer = annotation.subtitle!
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        eTitle = (view.annotation?.title)!
        eOrganizer = (view.annotation?.subtitle)!
        self.performSegue(withIdentifier: "mapToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToDetail" {
            print("prepare for segue to detail called")
            
            if let detailedVC = segue.destination as? detailedViewController {
                detailedVC.eTitle = self.eTitle!
                detailedVC.eOrganizer = self.eOrganizer!
            }
        }
    }
    
    func showNearbyAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
