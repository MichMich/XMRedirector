//
//  AppDelegate.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 11-09-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application( application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary? ) -> Bool {
    
        var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application( application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData! ) {
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: " " ) as String
        
        println( deviceTokenString )
        
        Api.sharedInstance.deviceIdentifier = deviceTokenString
        
        Api.sharedInstance.performRequestWithUri("register") {
            (json, error) -> () in
            if (error != nil) {
                println("Error: \(error)")
            } else {
                println("Device registered.")
            }
        }
        
    }
    
    func application( application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError! ) {
        
        println( error.localizedDescription )
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //if let apn: AnyObject = userInfo["aps"]  {
            
        if let apn = userInfo["aps"] as? Dictionary<String, AnyObject> {
            if let alert = apn["alert"] as? String {
                
                var alert = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    //Ok pressed.
                }))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: { () -> Void in
                    //Shown;
                    
                    Contacts.sharedInstance.fetchContacts()
                    
                    
                    
                    
                })
                
            }
            
            if let sound = apn["sound"] as? String {
                
                let fileAttributes = sound.componentsSeparatedByString(".")
                
                if fileAttributes.count == 2 {
                    let soundURL = NSBundle.mainBundle().URLForResource(fileAttributes[0], withExtension: fileAttributes[1])
                    var mySound: SystemSoundID = 0
                    AudioServicesCreateSystemSoundID(soundURL, &mySound)
                    AudioServicesPlaySystemSound(mySound);
                }
                
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

