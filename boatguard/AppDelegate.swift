//
//  AppDelegate.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {

        var rootController:UIViewController? = nil
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            rootController = storyboard.instantiateViewControllerWithIdentifier("TabController") as? UIViewController
        } else {
            let storyboard = UIStoryboard(name: "Main_ipad", bundle: nil)
            rootController = storyboard.instantiateViewControllerWithIdentifier("TabController") as? UIViewController
        }

        // get your storyboard
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        if self.window != nil {
            self.window!.rootViewController = rootController
            self.window!.makeKeyAndVisible()
        }
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert |
            UIUserNotificationType.Badge, categories: nil))
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        states.setIsBackground(true)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        states.setIsBackground(false)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
