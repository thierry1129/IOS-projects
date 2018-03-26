//
//  functions.swift
//
//
//  Created by Rocomenty on 4/11/17.
//
//

import Foundation
import UIKit
import MapKit
import FirebaseAuth

func isValidActivity(theActivity: Activities) -> Bool {
    return !theActivity.title.isEmpty && !theActivity.organizer.isEmpty
    
}

func formatActivityData(theActivity: Activities) -> [String:Any] {
    
    return ["title":theActivity.title, "type":theActivity.activityToString(), "organizer": theActivity.organizer, "longitude": String(theActivity.location.longitude), "latitude": String(theActivity.location.latitude), "time": dateToString(date: theActivity.startTime),"attendee":theActivity.attendee , "description" : theActivity.description, "date": [".sv": "timestamp"]]
}

func stringToActivityType(str: String) -> Activities.ActivityType {
    if str == "Academic" {
        return Activities.ActivityType.Academic
    }
    else if str == "Student Organization" {
        return Activities.ActivityType.StudentOrganization
    }
    else {
        return Activities.ActivityType.Personal
    }
}

func activityTypeToString (at: Activities.ActivityType) ->String{
    
    
    
    if at == Activities.ActivityType.Academic {
        return "Academic"
    }
    else if at == Activities.ActivityType.StudentOrganization{
        return "Student Organization"
    }
    else{
        return "Personal"
    }
    
    
}

func cllocationToString(location: CLLocationCoordinate2D) -> String {
    return String(location.longitude) + ", " + String(location.latitude);
}

func cllocationToStringWithTrim(location: CLLocationCoordinate2D) -> String {
    return "Longitude: " + String(Double(round(1000*location.longitude)/1000)) + ", Latitude: " + String(Double(round(1000*location.latitude)/1000))
}

func dateToString(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    return dateFormatter.string(from: date)
}
func stringToDate (dateString: String) ->Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    let date = dateFormatter.date(from: "\(dateString)")
    
    return date!
    
}
func getOrange() -> UIColor {
    return UIColor(red:0.97, green:0.71, blue:0.36, alpha:1.0)
}

func parseAddress(selectedItem:MKPlacemark) -> String {
    // put a space between "4" and "Melrose Place"
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    // put a comma between street and city/state
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    // put a space between "Washington" and "DC"
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
        format:"%@%@%@%@%@%@%@",
        // street number
        selectedItem.subThoroughfare ?? "",
        firstSpace,
        // street name
        selectedItem.thoroughfare ?? "",
        comma,
        // city
        selectedItem.locality ?? "",
        secondSpace,
        // state
        selectedItem.administrativeArea ?? ""
    )
    return addressLine
}

func formatAttendeeText(attendees: [String]) -> String {
    var str = ""
    for index in 0..<attendees.count {
        if (index != attendees.count-1) {
            str += attendees[index] + ", "
        }
        else {
            str += attendees[index]
        }
    }
    return str
}
