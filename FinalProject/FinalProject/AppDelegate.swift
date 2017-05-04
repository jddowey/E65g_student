//
//  AppDelegate.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let strings = ["Tumbler": ["alive":[[11,12],[11,13],[11,15],[11,16],[12,12],[12,13],[12,15],[12,16],[13,13],[13,15],[14,11],[14,13],[14,15],[14,17],[15,11],[15,13],[15,15]]]
    ]
    var userDefaultsVariationInstance: GridVariation!
    var gridVariations: GridVariation!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //access to the GridVariations (json and user saved data) singleton
        userDefaultsVariationInstance = GridVariation(data: ["initial row": ["alive": [[0, 0]]]])

        //saving to user defaults
        let defaults = UserDefaults.standard
        defaults.set(strings, forKey: "strings")
        let recoveredStrings = defaults.object(forKey: "strings")
        print("defaults \(defaults)")
        print("recoveredStrings \(recoveredStrings)")
        
        // Override point for customization after application launch.
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func applicationDidFinishLaunching(_ application: UIApplication) {
        

        func loadJson() -> NSDictionary? {
            
            if let url = Bundle.main.path(forResource: "userGridVariation", ofType: "json") {
                if let data = FileManager.default.contents(atPath: url) {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                        print("DICTIONARY \(dictionary)")
                        
                        return dictionary
                    } catch {
                        print("Error!! Unable to parse  userGridVariation.json")
                    }
                }
                print("Error!! Unable to load  userGridVariation.json")
            }
            
            return nil
        }
//        _ = loadJson()
    }
    
        

}

