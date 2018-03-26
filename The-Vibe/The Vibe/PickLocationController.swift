//
//  PickLocationController.swift
//
//
//  Created by Rocomenty on 4/17/17.
//
//

//adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

//adapted from http://stackoverflow.com/questions/37472076/how-to-pass-data-when-the-back-button-clicked
public protocol DataBackDelegate: class {
    func saveData(chosedLocation: CLLocationCoordinate2D?)
}

class PickLocationController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var chosedLocation: CLLocationCoordinate2D?
    weak var delegate: DataBackDelegate?
    
    var hasSetCurrentLocation: Bool = false
    var isSearched: Bool = false
    
    var resultSearchController: UISearchController? = nil
    
//    override func viewWillAppear(_ animated: Bool) {
//        setUpSearchController()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        showPickAlert(title: "Note", msg: "To pick a location, long press on the map to move the orange pin to desired location. Then press the pin and click the orange check button to choose the pinned location")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpAnnotation(currentLocation: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        mapView.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
//    func setUpSearchController() {
//        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController?.searchResultsUpdater = locationSearchTable
//        
//        let searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for locations"
//        self.navigationItem.titleView = resultSearchController!.searchBar
//        
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
//        
//        locationSearchTable.mapView = mapView
//        locationSearchTable.handleMapSearchDelegate = self
//        
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            if (!hasSetCurrentLocation) {
                setUpAnnotation(currentLocation: last.coordinate)
                hasSetCurrentLocation = true
            }
        }
        
    }
    
    //adapted from https://www.youtube.com/watch?v=pt_hbo85OkI
    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        let touchLocatoin = sender.location(in: self.mapView)
        let geoLocation = self.mapView.convert(touchLocatoin, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = geoLocation
        annotation.title = "Pick this location"
        chosedLocation = geoLocation
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    //adapted from https://www.youtube.com/watch?v=wl2kqGixL90
    func changeMapSize(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setLocation() {
        self.delegate?.saveData(chosedLocation: chosedLocation)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showPickAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

extension PickLocationController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        chosedLocation = placemark.coordinate
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        //        let span = MKCoordinateSpanMake(0.05, 0.05)
        //        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension PickLocationController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "checkmark.png"), for: .normal)
        button.addTarget(self, action: #selector(setLocation), for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = button
        return pinView
    }
    
    
    
    
}
