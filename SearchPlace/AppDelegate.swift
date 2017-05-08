//
//  AppDelegate.swift
//  SearchPlace
//
//  Created by Deblina Das on 18/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupFramework()
        return true
    }
    
    func setupFramework() {
        GMSPlacesClient.provideAPIKey("AIzaSyABc86A77BAgBXj7i4VwADTp3T0WYbW7cw")
    }
}

