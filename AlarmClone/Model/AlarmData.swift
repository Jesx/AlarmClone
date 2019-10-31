//
//  AlarmData.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

class AlarmData {
    
    static func saveData(alarmArray: [Alarm]) {
        // Use PropertyListEncoder to convert Player into Data / NSData
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alarmArray), forKey: "alarmArrayKey")
    }
    
    static func loadData() -> [Alarm] {
        guard let alarms = UserDefaults.standard.object(forKey: "alarmArrayKey") as? Data else { return [Alarm]() }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let alarmArray = (try? PropertyListDecoder().decode([Alarm].self, from: alarms)) else { return [Alarm]() }
        
        return alarmArray
    }
}
