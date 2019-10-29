//
//  AlarmData.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

class AlarmData {
    
    static func saveData(timeArray: [TimeElement]) {
        // Use PropertyListEncoder to convert Player into Data / NSData
        UserDefaults.standard.set(try? PropertyListEncoder().encode(timeArray), forKey: "timeArray")
    }
    
    static func loadData() -> [TimeElement] {
        guard let timeData = UserDefaults.standard.object(forKey: "timeArray") as? Data else { return [TimeElement]() }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let timeArray = (try? PropertyListDecoder().decode([TimeElement].self, from: timeData)) else { return [TimeElement]() }
        
        return timeArray
    }
    
//    static func saveRepeatStatus(repeatStatusArray: [String]) {
//        // Use PropertyListEncoder to convert Player into Data / NSData
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(repeatStatusArray), forKey: "repeatArray")
//    }
//
//    static func loadRepeatStatus() -> [String] {
//        guard let repeatData = UserDefaults.standard.object(forKey: "repeatArray") as? Data else { return [String]() }
//
//        // Use PropertyListDecoder to convert Data into Player
//        guard let repeatArray = (try? PropertyListDecoder().decode([String].self, from: repeatData)) else { return [String]() }
//
//        return repeatArray
//    }
}
