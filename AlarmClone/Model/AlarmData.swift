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
        do {
            let alarms = try PropertyListEncoder().encode(alarmArray)
            UserDefaults.standard.set(alarms, forKey: "alarmsKey")
        } catch {
            print("Save data error.")
        }
    }
    
    static func loadData() -> [Alarm] {
        guard let alarms = UserDefaults.standard.object(forKey: "alarmsKey") as? Data else { return [Alarm]() }
        
        // Use PropertyListDecoder to convert Data into Player
        
        guard let alarmArray = (try? PropertyListDecoder().decode([Alarm].self, from: alarms)) else {
            print("Load data error.")
            return [Alarm]() }
        
        return alarmArray
    }
}
