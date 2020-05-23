//
//  LocationService.swift
//  LyftClone
//
//  Created by אדיר נוימן on 13/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import Foundation

class LocationService {
    
    static let shared = LocationService()
    
    // Create an empty array of locations
    
    private var recentLocations = [Location]()
    
    // Seeding the data
    
    
    private init() {
        
      let locationsUrl =  Bundle.main.url(forResource: "locations", withExtension: "json")!
        
      let data = try! Data(contentsOf: locationsUrl)
      let decoder = JSONDecoder()
      recentLocations = try! decoder.decode([Location].self, from: data)
        
        
    }
    
    func getRecentLocations() -> [Location] {
        
        return recentLocations
    }
}
