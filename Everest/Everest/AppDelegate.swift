//
//  AppDelegate.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let centerNotification = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //setup notification observers
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil, queue: OperationQueue.main, using: {(Notification) -> () in
            //TODO: perform any needed cleanup here
            self.switchToLoginController()
        })
        
        registerForPushNotifications()
        if let actionNotificationsData = UserDefaults.standard.object(forKey: "actionNotifications") as? NSData {
            let actionNotifications = NSKeyedUnarchiver.unarchiveObject(with: actionNotificationsData as Data) as? [Act]
            SettingsViewController.actionNotifications = actionNotifications!
        }
        
        //Firebase setup
        FirebaseApp.configure()
        
        //Facebook setup
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //App setup
        MainManager.shared.initialize()
        
        return true
    }
    
    func switchToLoginController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        window?.rootViewController = vc
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
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func registerForPushNotifications() {
        centerNotification.delegate = self
        centerNotification.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
            if (granted) {
                UIApplication.shared.registerForRemoteNotifications()
            } else{
                print("Notification permissions not granted")
            }
        })
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let actDect = notification.request.content.userInfo
        handelingRemoteNotification(actDect: actDect as NSDictionary)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let actDect = response.notification.request.content.userInfo
        handelingRemoteNotification(actDect: actDect as NSDictionary)
        
    }
    
    func handelingRemoteNotification(actDect: NSDictionary) {
        SettingsViewController.actionNotifications.append(Act(id: actDect["id"] as! String, category: actDect["category"] as! String, title: actDect["title"] as! String, score: Int(actDect["score"] as! String)!) )
        
        let actionNotifications = NSKeyedArchiver.archivedData(withRootObject: SettingsViewController.actionNotifications)
        UserDefaults.standard.set(actionNotifications, forKey: "actionNotifications")
    }
    
}

