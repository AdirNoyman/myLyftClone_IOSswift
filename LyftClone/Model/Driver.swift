//
//  Driver.swift
//  LyftClone
//
//  Created by אדיר נוימן on 25/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation

class Driver {
    
    let name: String
    let thumbnail: String
    let licenseNumber: String
    let rating: Float
    let car: String
    
    
    init(name: String,thumbnail: String,licenseNumber: String,rating: Float,car: String ) {
        
        self.name = name
        self.thumbnail = thumbnail
        self.licenseNumber = licenseNumber
        self.rating = rating
        self.car = car
        
    }   
    
}
