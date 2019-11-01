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

    enum DaysOfWeek: String, CaseIterable {
        case Sunday, Monday, Tuesday, Wednesday, Thusday, Friday, Saturday
        var index: Int { DaysOfWeek.allCases.firstIndex(of: self)! }
    }
    
    enum repeatAdditional {
        case Never, Everday, Weekend
        
        var destription: String {
            switch self {
            case .Never: return "Never"
            case .Everday: return "Every day"
            case .Weekend: return "Weekend"
            }
        }
    }
}

extension Array where Element == DetailInfo.DaysOfWeek {

    var uiString: String {
        switch self {
        case []:
            return DetailInfo.repeatAdditional.Never.destription
        case [.Sunday, .Monday, .Tuesday, .Wednesday, .Thusday, .Friday,.Saturday]:
            return DetailInfo.repeatAdditional.Everday.destription
        case [.Sunday, .Saturday]:
            return DetailInfo.repeatAdditional.Weekend.destription
        default:
            return map{ $0.rawValue.prefix(3) }.joined(separator: " ")
        }
    }
    
    var uiStringMain: String {
        switch uiString {
        case DetailInfo.repeatAdditional.Never.destription:
            return ""
        case DetailInfo.repeatAdditional.Everday.destription:
            return ", \(uiString.lowercased())"
        case DetailInfo.repeatAdditional.Weekend.destription:
            return ", every \(uiString.lowercased())"
        default:
            return ", \(uiString)"
        }
    }
    
}
