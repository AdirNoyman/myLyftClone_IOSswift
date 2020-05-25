//
//  HomeViewController.swift
//  LyftClone
//
//  Created by אדיר נוימן on 17/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var searchButton: UIButton!
    var locations = [Location]()
    var locationManager: CLLocationManager!
    var currentUserLoaction: Location!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recentLocations = LocationService.shared.getRecentLocations()
        locations = [recentLocations[0], recentLocations[1]]
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
        }
        
        
        // Add shadow to searchButton
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.shadowRadius = 1.0
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 1.5, height: 0.5)
        searchButton.layer.shadowOpacity = 0.5
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let locationViewController = segue.destination as? LocationViewController {
            
            locationViewController.pickupLocation = self.currentUserLoaction
            
        } else if let routeViewContrroler = segue.destination as? RouteViewController, let dropOffLocation = sender as? Location {
            
            routeViewContrroler.pickUpLocation = self.currentUserLoaction
            routeViewContrroler.dropOffLocation = dropOffLocation
            
            
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let firstLocation = locations.first!
        currentUserLoaction = Location(title: "Current user location", subtitle: "", lat: firstLocation.coordinate.latitude, lng: firstLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dropoffLocation = locations[indexPath.row]
        performSegue(withIdentifier: "RouteSegue", sender: dropoffLocation)
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        // zoom in the user location
        let distance = 200.0
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
        // Add user location as the center area
        let lat = userLocation.coordinate.latitude
        let lng = userLocation.coordinate.longitude
        let offset = 0.00075
        let coordinate1 = CLLocationCoordinate2D(latitude: lat - offset, longitude: lng - offset)
        let coordinate2 = CLLocationCoordinate2D(latitude: lat, longitude: lng + offset)
        let coordinate3 = CLLocationCoordinate2D(latitude: lat, longitude: lng - offset)
        
        // Creating 3 vehicles annotation and add them to the mapview
        mapView.addAnnotations([
        VahicleAnnotation(coordinate: coordinate1),
        VahicleAnnotation(coordinate: coordinate2),
        VahicleAnnotation(coordinate: coordinate3),
        
        ])
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            
            return nil
            
            
        }
        
        // Create our custom annotation view with vehicle image
        let reuseIdentifier = "VahicleAnnotation"
        var annotationView  = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
    
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
        } else {
            
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "car")
        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(360) * 180) / CGFloat.pi)
        return annotationView
        
    }
}
