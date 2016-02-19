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
        // House all the markers in a map
        /*
        self.usersToMarkers_ = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"];
        // Listen for new users
        [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *s2) {
        // Listen for updates for each user
        [[ref childByAppendingPath:s2.name] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Check to see if user was updated or removed
        if (snapshot.value != [NSNull null]) {
        // Location updated, create/move the marker
        GMSMarker *marker = [self.usersToMarkers_ objectForKey:snapshot.name];
        if (!marker) {
        marker = [[GMSMarker alloc] init];
        marker.title = snapshot.name;
        marker.map = self.mapView_;
        [self.usersToMarkers_ setObject:marker forKey:snapshot.name];
        }
        marker.position = CLLocationCoordinate2DMake([snapshot.value[@"coords"][@"latitude"] doubleValue], [snapshot.value[@"coords"][@"longitude"] doubleValue]);
        } else {
        // User was removed, remove the marker
        GMSMarker *marker = [self.usersToMarkers_ objectForKey:snapshot.name];
        if (marker) {
        marker.map = nil;
        [self.usersToMarkers_ removeObjectForKey:snapshot.name];
        }
        }
        }];
        }];*/
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





