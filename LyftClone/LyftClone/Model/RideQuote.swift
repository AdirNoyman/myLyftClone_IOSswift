//
//  RideQuote.swift
//  LyftClone
//
//  Created by אדיר נוימן on 14/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation

class RideQuote {
    
    let thumbnail: String
    let name: String
    let capacity: String
    let price: Double
    let time: Date
    
    init(thumbnail: String,name: String,capacity: String,price: Double,time: Date) {
        
        
        self.thumbnail = thumbnail
        self.name = name
        self.capacity = capacity
        self.price = price
        self.time = time
        
        
    }
    
}
