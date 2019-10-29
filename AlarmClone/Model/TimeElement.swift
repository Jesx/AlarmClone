//
//  timeElement.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

struct TimeElement: Codable {
    var uuid: String
    var time: Time
    var textLabel: String
    var ringTone: String
    var repeatStatus: [DetailInfo.DaysOfWeek]
    var isOn: Bool
}

struct Time: Codable {
    var hour: Int
    var min: Int
    
    var timeString: String {
        let formatter = DateFormatter.dateFormat(fromTemplate: "h:mm a", options: 0, locale: .current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = formatter
        return dateFormatter.string(from: date)
    }
    
    var date: Date { DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 29, hour: hour, minute: min, second: 20).date! }
    
    func get(array: [String]) -> [Date] {
        //https://stackoverflow.com/questions/47223014/get-next-tuesday-and-thursday-from-current-date-in-swift?rq=1
        fatalError()
        return [date]
    }
}

extension DetailInfo.DaysOfWeek: Codable {
    
}
