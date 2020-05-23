//
//  RouteViewController.swift
//  LyftClone
//
//  Created by אדיר נוימן on 23/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectRideButton: UIButton!
    
    var selectedIndex = 0
    var pickUpLocation: Location?
    var dropOffLocation: Location?
    var rideQuotes = [RideQuote]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounding the corners
        routeLabelContainer.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        selectRideButton.layer.cornerRadius = 10.0
        
        
        // Populating properties for testing purposes
        let locations = LocationService.shared.getRecentLocations()
        pickUpLocation = locations[0]
        dropOffLocation = locations[1]
        
        rideQuotes = RideQuoteService.shared.getQuotes(pickupLocation: pickUpLocation!, dropOffLocation: dropOffLocation!)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideQuotes.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideQuoteCell")  as! RideQuoteCell
        
        let rideQuote = rideQuotes[indexPath.row]
        cell.Update(rideQuote: rideQuote)
        cell.updateSelectStatus(status: indexPath.row == selectedIndex)
        
        return cell
        
      }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        let selectedRideQuote = rideQuotes[indexPath.row]
        selectRideButton.setTitle("Select \(selectedRideQuote.name)", for: .normal)
        
        tableView.reloadData()
        
    }
}

