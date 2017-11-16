//
//  AppDelegate.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterPush
import AppCenterDistribute
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MSCrashesDelegate,MSPushDelegate,MSDistributeDelegate {
                            
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MSCrashes.setDelegate(self)
        MSPush.setDelegate(self)
        MSDistribute.setDelegate(self)
        // Depending on the user's choice, call notify() with the right value.
        MSDistribute.notify(MSUpdateAction.update);
        MSDistribute.notify(MSUpdateAction.postpone);
        MSAppCenter.setLogUrl("https://in-staging-south-centralus.staging.avalanch.es")
        MSAppCenter.start("f7b2bb1f-12d7-44c0-a70a-87291cbc5f9e", withServices:[
            MSAnalytics.self,
            MSCrashes.self,
            MSPush.self,
            MSDistribute.self
            ])        // Override point for customization after application launch.
        MSAnalytics.trackEvent("launch");
        
        MSAppCenter.setLogLevel(MSLogLevel.verbose)
        var installId = MSAppCenter.installId()
        
        var customProperties = MSCustomProperties()
        customProperties.setString("blue", forKey: "color")
        customProperties.setNumber(10, forKey: "score")
        customProperties.clearProperty(forKey: "score")
        MSAppCenter.setCustomProperties(customProperties)
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
    
    func attachments(with crashes: MSCrashes, for errorReport: MSErrorReport) -> [MSErrorAttachmentLog] {
        let attachment1 = MSErrorAttachmentLog.attachment(withText: "Hello world!", filename: "hello.txt")
        let attachment2 = MSErrorAttachmentLog.attachment(withBinary: "Fake image".data(using: String.Encoding.utf8), filename: nil, contentType: "image/jpeg")
        return [attachment1!, attachment2!]
    }
    func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
        var message: String = pushNotification.message
        for item in pushNotification.customData {
            message = String(format: "%@\n%@: %@", message, item.key, item.value)
        }
        let alert = UIAlertView(title: pushNotification.title, message: message, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    func distribute(_ distribute: MSDistribute!, releaseAvailableWith details: MSReleaseDetails!) -> Bool {
        
        // Your code to present your UI to the user, e.g. an UIAlertView.
        UIAlertView.init(title: "Update available", message: "Do you want to update?", delegate: self as! UIAlertViewDelegate, cancelButtonTitle: "Postpone", otherButtonTitles: "Update").show()
        // Depending on the user's choice, call notify() with the right value.
        MSDistribute.notify(MSUpdateAction.update);
        MSDistribute.notify(MSUpdateAction.postpone);
        return true;
    }
}

