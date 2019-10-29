//
//  DetailInfo.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

enum DetailInfo {
    static let ringTone = [
        "Apex","Beacon", "Bulletin", "Hillside", "Radar",
        "Reflection","Ripples", "Silk", "Slow Rise", "Waves"
    ]
    
    static let repeatArray: [String] = DaysOfWeek.allCases.map { $0.rawValue }
    
    static let repeatAdditionalArray = ["Never", "Every day", "Weekend"]
    
    enum DaysOfWeek: String, CaseIterable {
        case Sunday, Monday, Tuesday, Wednesday, Thusday, Friday, Saturday
    }
}

extension Array where Element == DetailInfo.DaysOfWeek {

    var uiString: String {
        
        switch self {
        case []:
            return DetailInfo.repeatAdditionalArray[0]
        case [.Sunday, .Monday, .Tuesday, .Wednesday, .Thusday, .Friday,.Saturday]:
            return DetailInfo.repeatAdditionalArray[1]
        case [.Sunday, .Saturday]:
            return DetailInfo.repeatAdditionalArray[2]
        default:
            return map{$0.rawValue.prefix(3)}.joined(separator: " ")
        }
    }
}
