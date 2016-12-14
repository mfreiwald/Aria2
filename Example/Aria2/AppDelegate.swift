//
//  AppDelegate.swift
//  Aria2
//
//  Created by Michael Freiwald on 12/01/2016.
//  Copyright (c) 2016 Michael Freiwald. All rights reserved.
//

import UIKit
import Aria2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var aria:Aria2?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        
        self.aria = Aria2.connect(url: "", token: "")
        
        /*
        if let websocket = self.aria as? Aria2WebSocket {
            websocket.autoReconnect = true
            websocket.onDownloadStart = { gid in
                print("Download \(gid) start")
            }
            websocket.onDownloadComplete = { gid in
                print("Download \(gid) complete")
            }
        }
        */
        
        let add = RPCCall.addUri(["http://ipv4.download.thinkbroadband.com/20MB.zip"], {(result) in
            switch(result) {
            case let .Success(gid): print("success " + gid.gid)
            case let .Failure(_): print("failure")
            }
        })
 
        let stats = RPCCall.getGlobalStat { (result) in
            switch(result) {
            case let .Success(global): print("success \(global.numStoppedTotal)")
            case let .Failure(_): print("failure")
            }
        }
        
        self.aria!.call(methods: [add, stats])

        
        /*
        self.aria!.addUri("http://ipv4.download.thinkbroadband.com/20MB.zip", { result in
            switch result {
            case let .Success(gid): print("success \(gid.gid)")
            case let .Failure(error): print("failure")
            }
        }).addUri("http://ipv4.download.thinkbroadband.com/10MB.zip", { (result) in
            switch result {
            case let .Success(gid): print("success \(gid.gid)")
            case let .Failure(error): print("failure")
            }
        }).response()
        */
        
        /*
        self.aria!.addUri("http://ipv4.download.thinkbroadband.com/20MB.zip") { (gid) in
            print(gid?.gid)
        }.addUri("http://ipv4.download.thinkbroadband.com/10MB.zip") { (gid) in
            print(gid?.gid)
        }.response()
        */
        
        /*
        self.aria!.multicall(uri1: "http://ipv4.download.thinkbroadband.com/20MB.zip", uri2: "http://ipv4.download.thinkbroadband.com/10MB.zip") { (response) in
            print(response?.id)
        }
        */
        /*
        var calls = [String:[Any]]()
        // token fehlt
        calls["aria2.addUri"] = ["http://ipv4.download.thinkbroadband.com/20MB.zip"]
        //calls["aria2.getGlobalStat"] = [""]
        self.aria!.multicall(params: calls, { (response) in
            print(response?.id)
        })
        */
        
        
        
        /*
        self.aria!.getGlobalStat { (data) in
            guard let stats = data as? GlobalStat else {
                return
            }
            print("Downloadspeed: \(stats.downloadSpeed)")
        }
        */
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

