//
//  AppDelegate.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("Allowed.")
            } else {
                print("Not allowed.")
            }
        })
        
        // Add category
        let snoozeAction = UNNotificationAction(identifier: NotificationAction.Snooze.rawValue, title: NotificationAction.Snooze.rawValue, options: [])
        let dislikeAction = UNNotificationAction(identifier: NotificationAction.Stop.rawValue, title: NotificationAction.Stop.rawValue, options: [.destructive])
        
        let category = UNNotificationCategory(identifier: NotificationCategory.AlarmNotification.rawValue, actions: [snoozeAction, dislikeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Showing notification at foreground
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Get notification at foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.badge, .sound, .alert])
        completionHandler([.sound, .alert])
        print("Get notification at foreground...")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case NotificationAction.Snooze.rawValue:

//            response.notification.request.content.
            break
        case NotificationAction.Stop.rawValue:
            
            break
        default:
            break
        }
        
        completionHandler()
    }
}

