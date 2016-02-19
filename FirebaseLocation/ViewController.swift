//
//  ViewController.swift
//  FirebaseLocation
//
//  Created by Alexander Blokhin on 18.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = view.center
        
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Not logged in")
        } else {
            print("Logged In")
            authToFirebase()
        }
    }
    
    
    func authToFirebase() {
        let ref = Firebase(url: "https://location-app.firebaseio.com")
        
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        ref.authWithOAuthProvider("facebook", token: accessToken,
            withCompletionBlock: { error, authData in
                if error != nil {
                    print("Login failed. \(error)")
                } else {
                    print("Logged in! \(authData)")
                    
                    let displayName = authData.providerData["displayName"] as? String
                    
                    self.performSegueWithIdentifier("showMap", sender: displayName)
                }
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap" {
            let vc = segue.destinationViewController as! MapViewController
            vc.displayName = sender as! String?
        }
    }
    
    
    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Login complete")
            
            authToFirebase()
            
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

