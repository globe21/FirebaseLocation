//
//  AppDelegate.swift
//  FirebaseLocation
//
//  Created by Alexander Blokhin on 18.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    var displayName: String?
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let wasHandled = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)

        if (wasHandled) {
            //authToFirebase()
        }
        // You can add your app-specific url handling code here if needed
        return wasHandled

        
    }
    
    
    
    
    // Notify firebase that user has logged in
    func authToFirebase()
    {
        /*
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    // if we have an access token, authenticate to firebase
    if (fbAccessToken) {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"];
    [ref authWithOAuthProvider:@"facebook" token:fbAccessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
    NSLog(@"Error on login %@", error);
    } else if (authData) {
    self.displayName_ = authData.providerData[@"displayName"];
    NSLog(@"Logged In: %@", self.displayName_);
    [self startLocationUpdates];
    } else {
    NSLog(@"Logged out");
    }
    }];
    } else {
    NSLog(@"No access token provided.");
    }*/
        
        let ref = Firebase(url: "https://location-app.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
            
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: window?.rootViewController, handler: { (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                        }
                })
            }
        })

        
    }
    
    // Notify firebase that user has logged out
    func deauthToFirebase()
    {
        if displayName != nil {
            let positionRef = Firebase(url: "https://location-app.firebaseio.com").childByAppendingPath(displayName)
            positionRef.removeValueWithCompletionBlock({ (error: NSError!, ref: Firebase!) -> Void in
                self.displayName = nil
                positionRef.unauth()
            })
        }
        
      //  stopLocationUpdates()
    }
    
    

    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //authToFirebase()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

