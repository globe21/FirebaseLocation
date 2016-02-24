//
//  MapViewController.swift
//  FirebaseLocation
//
//  Created by Alexander Blokhin on 19.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mapView: MKMapView!
    var usersToMarkers: NSMapTable?
    
    var locationManager: CLLocationManager?
    
    var tracking = false
    
    var displayName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMapsView()
        startLocationUpdates()
        listenForLocations()
    }
    
    
    // Set google maps as the view
    func loadMapsView()
    {
        // Initialize the map to Moscow
        
        mapView = MKMapView(frame: view.frame)
        
        let location = CLLocationCoordinate2D(
            latitude: 55.755833,
            longitude: 37.617778
        )

        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = true
        
        self.view = mapView
    }
    
    
    // Setup firebase listerners to handle other users' locations
    func listenForLocations()
    {
        usersToMarkers = NSMapTable(keyOptions: .StrongMemory, valueOptions: .WeakMemory)
        let usersRef = Firebase(url: "https://location-app.firebaseio.com/users")
        
        // Listen for new users
        
        usersRef.observeEventType(FEventType.ChildAdded) { (snapshot: FDataSnapshot!) -> Void in
            // Listen for updates for each user
            usersRef.childByAppendingPath(snapshot.key).observeEventType(FEventType.Value, withBlock: { (snapshot2: FDataSnapshot!) -> Void in
                
                if snapshot2.value != nil {
                    // Location updated, create/move the marker
                    
                    let coord = snapshot2.value.valueForKey("coords") as! NSDictionary

                    let position = CLLocationCoordinate2DMake(coord["latitude"]!.doubleValue, coord["longitude"]!.doubleValue)
                    
                    var annotation = self.usersToMarkers?.objectForKey(snapshot.key) as! MKPointAnnotation?
                    
                    if annotation == nil {
                        annotation = MKPointAnnotation()
                        annotation!.title = snapshot.key
                        self.mapView.addAnnotation(annotation!)
                        self.usersToMarkers?.setObject(annotation, forKey: snapshot.key)
                    }
                    
                    annotation!.coordinate = position
                } else {
                    // User was removed, remove the marker
                    let annotation = self.usersToMarkers?.objectForKey(snapshot.key) as! MKPointAnnotation?
                    if (annotation != nil) {
                        self.mapView.removeAnnotation(annotation!)
                        self.usersToMarkers?.removeObjectForKey(snapshot.key)
                    }
                }
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Start updating location
    func startLocationUpdates()
    {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        locationManager!.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 5
        
        locationManager!.requestWhenInUseAuthorization()
        
        locationManager!.startUpdatingLocation()
    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .AuthorizedWhenInUse) {
            locationManager!.startUpdatingLocation()
        } else if (status == .AuthorizedAlways) {
            // iOS 7 will redundantly call this line.
            locationManager!.startUpdatingLocation()
        } else {//if (status > CLAuthorizationStatus.NotDetermined) {
            print("Could not fetch correct authorization status.")
        }
    }
    
    
    
    // Stop updating location
    func stopLocationUpdates()
    {
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
            locationManager = nil
        }
    }
    
    
    // This function executes once per location update
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
    
        if !tracking {
        
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
            mapView.setRegion(region, animated: true)
            
            tracking = true
        }
        
        
        let value = [
            "coords" : [
                "accuracy" : NSNumber(double: userLocation.horizontalAccuracy),
                "latitude" : NSNumber(double: userLocation.coordinate.latitude),
                "longitude" : NSNumber(double: userLocation.coordinate.longitude)],
            "timestamp" : NSNumber(longLong: Int64(userLocation.timestamp.timeIntervalSince1970 * 1000))]
        
        let positionRef = Firebase(url: "https://location-app.firebaseio.com/users").childByAppendingPath(displayName!)
        
        positionRef.setValue(value)
        positionRef.onDisconnectRemoveValue()
    }
}





