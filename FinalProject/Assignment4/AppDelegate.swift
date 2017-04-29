//
//  AppDelegate.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

var gridVariations = GridVariation()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var gridVariations = GridVariation(variationsData: ["initial" : [[0, 0]]])
    private var jsonArray: NSArray = []
//    var gridVariations = GridVariation()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        print("gridVariations \(gridVariations)")
        
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            print(json)
            self.jsonArray = json as! NSArray
            //            let resultString = (json as AnyObject).description
            //
            
            OperationQueue.main.addOperation {
                //                self.textView.text = resultString
                _ = self.getGridVariations()
            }
        }
print("again class gridVariations \(gridVariations.variationsData)")
        // Override point for customization after application launch.
        return true
    }
    func getGridVariations() -> [String : [[Int]]] {
        var jsonDictionaryArray: [String : [[Int]]] = [:]
        for i in 0..<self.jsonArray.count {
            let jsonDictionary = self.jsonArray[i] as! NSDictionary
            //                            jsonDictionaryArray.updateValue(jsonDictionary["contents"] as! [[Int]], forKey: jsonDictionary["title"] as! String)
            jsonDictionaryArray.updateValue(jsonDictionary["contents"] as! [[Int]], forKey: jsonDictionary["title"] as! String)
            //
            //                          let jsonDictionaryDic = jsonDictionary as! [String : [[Int]]]
            //                            var gridVariations = GridVariation(variationsData: jsonDictionaryDic)
            //                           self.gridVariations.variationsData = jsonDictionary as! [String : [[Int]]]
            print("jsonDictionary \(jsonDictionary)")
            print("jsonDictionaryArray \(jsonDictionaryArray)")
            gridVariations.variationsData = jsonDictionaryArray
            
            let jsonTitle = jsonDictionary["title"] as! String
            let jsonContents = jsonDictionary["contents"] as! [[Int]]
            
            print ("jsonTitle", jsonTitle, jsonContents)
            
        }
        print("class gridVariations \(gridVariations.variationsData)")
        
        return gridVariations.variationsData
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


}

