//
//  Vehicle.swift
//  LyftClone
//
//  Created by אדיר נוימן on 18/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import MapKit


class VahicleAnnotation: NSObject, MKAnnotation {
    
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    
    
}
