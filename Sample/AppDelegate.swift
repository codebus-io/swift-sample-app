//
//  AppDelegate.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/14.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var cdstore: CoreDataStore = {
        let cdstore = CoreDataStore()
        return cdstore
        }()
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let loggedIn = NSUserDefaults.standardUserDefaults().stringForKey("loggedIn") {
            
        } else {
            dispatch_after(3, dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("AuthenticationRequired", object: nil)
            })
        }
        
        let navigationBarAppearance:UINavigationBar = UINavigationBar.appearance()
        
        navigationBarAppearance.backIndicatorImage = UIImage(named: "navbar-back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationBarAppearance.backIndicatorTransitionMaskImage = UIImage(named: "navbar-back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        navigationBarAppearance.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 0.9)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden = false
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.cdh.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        self.cdh.saveContext()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        // handle Google+ auth URL
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

