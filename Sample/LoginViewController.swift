//
//  LoginViewController.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/14.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GPPSignInDelegate {

    var signIn:GPPSignIn!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.shouldFetchGoogleUserEmail = true
        
        signIn.clientID = "899577352192-dtj9ktde3sul1ndcijf4abehhitddqpm.apps.googleusercontent.com"
        signIn.scopes = [kGTLAuthScopePlusLogin,kGTLAuthScopePlusUserinfoEmail]
        signIn.delegate = self
        signIn.attemptSSO = false
        signIn.keychainName = "sample-dtj9ktde3sul1ndcijf4abehhitddqpm"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performLogin(sender: AnyObject) {
        signIn.authenticate()
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "loggedIn")
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            UIAlertView(title: "Login Error", message: "An error occured while trying to sign you in with your Google+ account, please try again later.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
        }
    }
}
