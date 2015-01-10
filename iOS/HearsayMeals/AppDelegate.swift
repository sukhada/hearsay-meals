//
//  AppDelegate.swift
//  HearsayMeals
//
//  Created by Mel Ludowise on 10/11/14.
//  Copyright (c) 2014 Mel Ludowise. All rights reserved.
//

import UIKit

private let kParseApplicationId = "myq9zbMzdkBqqEyudRcwIR5yxnmwihlslqUvYh34"
private let kParseClientKey = "sSDcYzwEBOuOGKYjuY28Skvalo2sImKNwXRt7v4q"

internal let kThemeColor = UIColor(red: 31/255.0, green: 120/255.0, blue: 179/255.0, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

    var window: UIWindow?
//    var applicationUrl: String?
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String,
        annotation: AnyObject?) -> Bool {
            setupColors()
            return GPPURLHandler.handleURL(url,
                sourceApplication:sourceApplication,
                annotation:annotation)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Use Parse
        Parse.setApplicationId(kParseApplicationId,
            clientKey: kParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
        
        // Update colors for the application
        setupColors()
        
        // Check for updates
        checkForUpdates()
        
        return true
    }
    
    func applicationSignificantTimeChange(application: UIApplication) {
        checkForUpdates()
    }
    
    private func setupColors() {
        // Custom tab bar color
        UITabBar.appearance().tintColor = kThemeColor
        UIButton.appearance().tintColor = kThemeColor
        UINavigationBar.appearance().tintColor = kThemeColor
    }
}
