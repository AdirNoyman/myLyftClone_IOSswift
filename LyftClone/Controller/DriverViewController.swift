//
//  DriverViewController.swift
//  LyftClone
//
//  Created by אדיר נוימן on 26/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import UIKit
import MapKit

class DriverViewController: UIViewController, MKMapViewDelegate {
    
    var pickupLocation: Location!
    var dropoffLocation: Location!
    
    
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverImageView.layer.cornerRadius = driverImageView.frame.size.width / 2.0
        licenseLabel.layer.cornerRadius = 15.0
        licenseLabel.layer.borderColor = UIColor.gray.cgColor
        licenseLabel.layer.borderWidth = 1.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        backButton.contentMode = .center
        
                
        let (driver, eta) = DriverService.shared.getDriver(pickupLocation: pickupLocation)
        
        etaLabel.text = "ARRIVES IN \(eta) MINUTES"
        driverNameLabel.text = driver.name
        licenseLabel.text = driver.licenseNumber
        ratingLabel.text = String(format: "%.1f", driver.rating)
        ratingImageView.image = UIImage(named: String(format: "rating-%.1f", driver.rating))
        carLabel.text = driver.car
        carImageView.image = UIImage(named: driver.car)
        driverImageView.image = UIImage(named: driver.thumbnail)
        
        mapView.delegate = self
        // Add annotations to the map view
        let driverAnnotation = VehicleAnnotation(coordinate: driver.coordinate)
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation!.lat, longitude: pickupLocation!.lng)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation!.lat, longitude: dropoffLocation!.lng)
        
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropoffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        
        let annotations: [MKAnnotation] = [driverAnnotation,pickupAnnotation, dropoffAnnotation]
        
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(annotations, animated: false)
        
        let driverLocation = Location(title: driver.name, subtitle: driver.licenseNumber, lat: driver.coordinate.latitude, lng: driver.coordinate.longitude)
        
        displayRoute(sourceLocation: driverLocation, destinationLocation: pickupLocation)
        
    }
    
    
    @IBAction func backButtonDidTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
      
    @IBAction func editRideButtonDidTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return nil
        }
        
        let reusIdentifier = annotation is VehicleAnnotation ? "VehicleAnnotation" : "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusIdentifier)
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusIdentifier)
            
        } else {
            
            annotationView?.annotation = annotation
            
        }
        
        if annotation is VehicleAnnotation {
            
            annotationView?.image = UIImage(named: "car")
            
        } else if let locationAnnotation = annotation as? LocationAnnotation {
            
            annotationView?.image = UIImage(named: "dot-\(locationAnnotation.locationType)")
        }
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendrer = MKPolylineRenderer(overlay: overlay)
        rendrer.lineWidth = 5.0
        rendrer.strokeColor = UIColor(red: 247.0/255.0, green: 66.0/255.0, blue: 190.0/255.0, alpha: 1)
        return rendrer
    }
    
    // Add the route layer to map view
    func displayRoute(sourceLocation: Location, destinationLocation: Location) {
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: sourceLocation.lat, longitude: sourceLocation.lng)
        let dastinationCoordinate = CLLocationCoordinate2D(latitude: destinationLocation.lat, longitude: destinationLocation.lng)
        
        // Placemarks
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: dastinationCoordinate)
        
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
                
            }
            
        })
        
        
    }
    
}
