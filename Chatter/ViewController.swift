//
//  ViewController.swift
//  Chatter
//
//  Created by Devesh Nema on 5/4/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    //MARK:- Constants
    let profilePicWidth : CGFloat = 100
    let profilePicHeight  : CGFloat = 100
    let profilePicY  : CGFloat = 100
    let fbLoginButtonY  : CGFloat = 200
    let fbLoginButtonHeight  : CGFloat = 50
    let fbLoginButtonXMargin  : CGFloat = 16
    
    let profilePictureView = FBSDKProfilePictureView()

    
    //MARK:- Outlets

    //MARK:- Delegate methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with FB")
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start {
            (connection, result, err) in
            if err != nil {
                print("Graph request failed")
                return
            }
        }
        
        profilePictureView.frame = CGRect(x: (view.frame.width/2 - profilePicWidth/2),y: profilePicY,width: profilePicWidth,height: profilePicHeight);
        profilePictureView.profileID = FBSDKAccessToken.current().userID
        view.addSubview(profilePictureView)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of FB")
        profilePictureView.removeFromSuperview()
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //Create the FB login button
        let fbLoginButton = FBSDKLoginButton()
        view.addSubview(fbLoginButton)
        fbLoginButton.frame = CGRect(x: fbLoginButtonXMargin, y: fbLoginButtonY, width: view.frame.width - (fbLoginButtonXMargin * 2), height: fbLoginButtonHeight)
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]
    }

    


}

