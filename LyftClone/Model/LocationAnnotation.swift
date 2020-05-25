//
//  LocationAnnotation.swift
//  LyftClone
//
//  Created by אדיר נוימן on 24/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation
import MapKit


class LocationAnnotation: NSObject, MKAnnotation {
    
    
    var coordinate: CLLocationCoordinate2D
    let locationType: String
    
    
    init(coordinate: CLLocationCoordinate2D, locationType: String) {
        
        self.coordinate = coordinate
        self.locationType = locationType
        
    }
    
    
}
