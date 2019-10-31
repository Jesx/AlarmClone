//
//  NotificationPush.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/26.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationCategory: String {
    case AlarmNotification
}

enum NotificationAction: String {
    case Snooze, Stop
}

class NotificationPush {
    
    func scheduleNotification(uuid: String, time: Time, label: String, sound: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm Notification"
        content.body = "This is the \(label) notificaion."
//        content.badge = 1
//        content.sound = UNNotificationSound.default
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "\(sound).mp3"))

        content.categoryIdentifier = NotificationCategory.AlarmNotification.rawValue

        let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: time.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
               print("Notificaion succeed.")
            }
        })
    }
    
    func deleteNotification(uuid: String) {
        let content = UNUserNotificationCenter.current()
        content.removePendingNotificationRequests(withIdentifiers: [uuid])
        
    }
}
