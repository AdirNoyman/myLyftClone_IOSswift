//
//  RouteViewController.swift
//  LyftClone
//
//  Created by אדיר נוימן on 23/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var pickUpLabel: UILabel!
    @IBOutlet weak var dropOffLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectRideButton: UIButton!
    
    var selectedIndex = 0
    var pickUpLocation: Location!
    var dropOffLocation: Location!
    var rideQuotes = [RideQuote]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounding the corners
        routeLabelContainer.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        selectRideButton.layer.cornerRadius = 10.0
        
        
        pickUpLabel.text = pickUpLocation?.title
        dropOffLabel.text = dropOffLocation?.title
        
        rideQuotes = RideQuoteService.shared.getQuotes(pickupLocation: pickUpLocation!, dropOffLocation: dropOffLocation!)
        
        // Add annotations to map view
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickUpLocation!.lat, longitude: pickUpLocation!.lng)
        let dropOffCoordinate = CLLocationCoordinate2D(latitude: dropOffLocation!.lat, longitude: dropOffLocation!.lng)
        
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropOffAnnotation = LocationAnnotation(coordinate: dropOffCoordinate, locationType: "dropoff")
        
        mapView.addAnnotations([pickupAnnotation,dropOffAnnotation])
        mapView.delegate = self
        
        displayRoute(sourceCoordinate: pickupCoordinate, destinationCoordinate: dropOffCoordinate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    // Back button
    
    @IBAction func backButtonDidPressed(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    // Add the route layer to map view
    func displayRoute(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        // Placemarks
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        // Directions
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {(response,error) in
            
            if let error = error {
                
                print("There is an error with calculating route \(error)")
                return
            }
            
            if let response = response {
                
                let route = response.routes.first!
                
                print(route)
                // Drawing the route on the map
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                // Zoom in and center the map's visible region on the route
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 80.0, bottom: 80.0, right: 80.0) , animated: true)
            }
            
        })
        
        
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendrer = MKPolylineRenderer(overlay: overlay)
        rendrer.lineWidth = 5.0
        rendrer.strokeColor = UIColor(red: 247.0/255.0, green: 66.0/255.0, blue: 190.0/255.0, alpha: 1)
        return rendrer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
        return nil
            
        }
        
        let reuseIdentifier = "LocationAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
        } else {
            
            annotationView!.annotation = annotation
            
        }
        
        let locatioAnnotation = annotation as! LocationAnnotation
        annotationView!.image = UIImage(named: "dot-\(locatioAnnotation.locationType)")
        return annotationView
        
    }
}

