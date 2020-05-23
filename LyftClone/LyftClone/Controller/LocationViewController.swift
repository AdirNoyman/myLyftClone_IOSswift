//
//  LocationViewController.swift
//  LyftClone
//
//  Created by אדיר נוימן on 19/05/2020.
//  Copyright © 2020 Adir Noyman. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations = [Location]()
    var pickupLocation: Location?
    var dropoffLocation: Location?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var dropOffTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = LocationService.shared.getRecentLocations()
        
        dropOffTextField.becomeFirstResponder()
        dropOffTextField.delegate = self
        searchCompleter.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    
    @IBAction func cancelDidTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let latestString = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        
        print("The latest string the user has entered is \(latestString)")
        
        if latestString.count > 3 {
            
            searchCompleter.queryFragment = latestString
        }
        
        
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        
        return searchResults.isEmpty ? locations.count : searchResults.count
        
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        
        if searchResults.isEmpty {
            
            let location = locations[indexPath.row]
            
            cell.update(location: location)
            
        } else {
            
            let searchResult = searchResults[indexPath.row]
            cell.update(searchResult: searchResult)
            
        }
        
        
        return cell
     }
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        
        // reload our table view
        tableView.reloadData()
    }
    
    
}
