//
//  Activities.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/7/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import Foundation
import MapKit



class Activities{
    
    
    var title: String
    var type: ActivityType
    var organizer: String
    
    var location: CLLocationCoordinate2D
    var startTime : Date
    var description: String
    var attendee: [String]
    
    init() {
        self.title = ""
        self.type = .Academic
        self.organizer = ""
        self.location = CLLocationCoordinate2D()
        self.startTime = Date()
        self.description = "No description"
        self.attendee = []
    }
    

    
    enum ActivityType {
        case Academic
        case StudentOrganization
        case Personal
    }
    
    func activityToString() -> String {
        if (self.type == .Academic) {
            return "Academic"
        }
        else if (self.type == .StudentOrganization) {
            return "Student Organization"
        }
        else {
            return "Personal"
        }
    }
    
}


