//
//  DriverService.swift
//  LyftClone
//
//  Created by אדיר נוימן on 25/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation
import CoreLocation

class DriverService {
    
    static let shared = DriverService()
    
    private init() {}
    
    func getDriver(pickupLocation: Location) -> (Driver, Int) {
        
        let locations = LocationService.shared.getRecentLocations()
        let randomLocation = locations[Int(arc4random_uniform(UInt32(locations.count)))]
        let coordinate = CLLocationCoordinate2D(latitude: randomLocation.lat, longitude: randomLocation.lng)
        let driver = Driver(name: "Koko Loko", thumbnail: "driver", licenseNumber: "8787GHT", rating: 5.0, car: "Hyundai Sonata", coordinate: coordinate)
        return(driver, 10)
        
    }
    
}
