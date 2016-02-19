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
    
    var hasOrientated = false
    
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
    
    // Change where the camera is on the map
    func updateCameraWithLocation(location: CLLocation) {
        /*
        NSLog(@"Updating camera");
        GMSCameraPosition *oldPosition = [self.mapView_ camera];
        GMSCameraPosition *position = [[GMSCameraPosition alloc] initWithTarget:[location coordinate] zoom:[oldPosition zoom] bearing:[location course] viewingAngle:[oldPosition viewingAngle]];
        [self.mapView_ setCamera:position];*/
    }
    
    
    // Logged-out user experience
    //func loginViewShowingLoggedOutUser(loginView: FBLoginView)
    //{
    /*
    NSLog(@"FB: logged out");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate deauthToFirebase];*/
    //}
    
    
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
        
        hasOrientated = false
        
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
        /*
        CLLocation *loc = locations[0];
        if (!self.hasOrientated_) {
        // Set map to the user's location on initial login
        ViewController* controller = (ViewController*) self.window.rootViewController;
        [controller updateCameraWithLocation:loc];
        self.hasOrientated_ = true;
        }
        if (self.displayName_) {
        // If the user has logged in, update firebase with the new location
        NSDictionary *value = @{
        @"coords": @{
        @"accuracy" : [NSNumber numberWithDouble:loc.horizontalAccuracy],
        @"latitude" : [NSNumber numberWithDouble:loc.coordinate.latitude],
        @"longitude" : [NSNumber numberWithDouble:loc.coordinate.longitude]
        },
        @"timestamp" : [NSNumber numberWithInt:[[NSNumber numberWithDouble:loc.timestamp.timeIntervalSince1970 * 1000] intValue]]
        };
        Firebase *positionRef = [[[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"] childByAppendingPath:self.displayName_];
        [positionRef setValue:value];
        // if the user disconnects, remove his data from firebase
        [positionRef onDisconnectRemoveValue];
        }*/
    }
    
}





