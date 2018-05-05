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
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of FB")
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //Create the FB login button
        let fbLoginButton = FBSDKLoginButton()
        view.addSubview(fbLoginButton)
        fbLoginButton.frame = CGRect(x: 16, y: 200, width: view.frame.width - 32, height: 50)
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]
    }

    


}

