//
//  LocationCell.swift
//  LyftClone
//
//  Created by אדיר נוימן on 17/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    
    
    @IBOutlet weak var addressLine1Label: UILabel!
    
    @IBOutlet weak var addressLine2Label: UILabel!
    
    func update(location: Location) {
        
        addressLine1Label.text = location.title
        addressLine2Label.text = location.subtitle
    }
    
    func update(searchResult: MKLocalSearchCompletion) {
        
        addressLine1Label.text = searchResult.title
        addressLine2Label.text = searchResult.subtitle
        
    }
    
}
