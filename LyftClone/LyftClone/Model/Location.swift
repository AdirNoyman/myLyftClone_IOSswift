//
//  Location.swift
//  LyftClone
//
//  Created by אדיר נוימן on 13/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation

class Location: Codable {
    
    var title: String
    var subtitle: String
    let lat: Double
    let lng: Double
    
    init(title: String, subtitle: String, lat: Double, lng: Double) {
        
        self.title = title
        self.subtitle = subtitle
        self.lat = lat
        self.lng = lng
        
    }
    
    
}
