//
//  Alarm.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

struct Alarm: Codable {
    var uuid: String
    var time: Time
    var textLabel: String
    var ringTone: String
    var repeatStatus: [DetailInfo.DaysOfWeek]
    var isOn: Bool
    var onSnooze: Bool
}

struct Time: Codable {
    var hour: Int
    var min: Int
    
    var timeString: String {
        let formatter = DateFormatter.dateFormat(fromTemplate: "h:mm a", options: 0, locale: .current)
        let dateFormatter = DateFormatter()
        
        if let formatter = formatter, formatter.contains("a") {
            dateFormatter.dateFormat  = "h:mma"
        } else {
            dateFormatter.dateFormat  = formatter
        }
        
        return dateFormatter.string(from: date)
    }
    
    var date: Date {
        dateComponents.date!
    }
    
    //
    var dateComponents: DateComponents {
        DateComponents(calendar: Calendar.current, hour: hour, minute: min, second: 0)
        
    }
}

extension DetailInfo.DaysOfWeek: Codable {
    
}
