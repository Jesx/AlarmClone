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
    
    func scheduleNotification(alarm: Alarm) {
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm Notification"
        content.body = "This is the \(alarm.textLabel) notificaion."
//        content.badge = 1
//        content.sound = UNNotificationSound.default
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "\(alarm.ringTone).mp3"))
        content.categoryIdentifier = NotificationCategory.AlarmNotification.rawValue

        let hour = alarm.time.hour
        let min = alarm.time.min
        
        if alarm.repeatStatus.count == 0 {
            let identifier = alarm.uuid
            let dateComponent = DateComponents(calendar: Calendar.current, hour: hour, minute: min, second: 0)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Notificaion succeed.")
                }
            }
            
        } else {
            for day in alarm.repeatStatus {
                let identifier = alarm.uuid + day.rawValue
                let weekday = day.index + 1
                let dateComponent = DateComponents(calendar: Calendar.current,
                                                   hour: hour,
                                                   minute: min,
                                                   second: 0,
                                                   weekday: weekday)
            
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in

                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Notificaion succeed.")
                    }
                }
            }
        }
        
    }
    
    func deleteNotification(alarm: Alarm) {
        var identifiers = [String]()
        let content = UNUserNotificationCenter.current()
        if alarm.repeatStatus.count == 0 {
            identifiers.append(alarm.uuid)
        } else {
            
            for day in alarm.repeatStatus {
                identifiers.append(alarm.uuid + day.rawValue)
            }
        }
        content.removePendingNotificationRequests(withIdentifiers: identifiers)
//        UNUserNotificationCenter.current().getPendingNotificationRequests{ dump($0)}
    }
}
