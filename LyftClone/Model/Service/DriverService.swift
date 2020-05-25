//
//  DriverService.swift
//  LyftClone
//
//  Created by אדיר נוימן on 25/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation

class DriverService {
    
    static let shared = DriverService()
    
    private init() {}
    
    func getDriver(pickupLocation: Location) -> (Driver, Int) {
        
        let driver = Driver(name: "Koko Loko", thumbnail: "kaki", licenseNumber: "8787GHT", rating: 4.5, car: "Porsche")
        return(driver, 10)
        
    }
    
}
