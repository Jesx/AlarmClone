//
//  ModelData.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

enum ModelData {
    static let ringTone = [
        "Apex","Beacon", "Bulletin", "Hillside", "Radar",
        "Reflection","Ripples", "Silk", "Slow Rise", "Waves"
    ]
    
    static let repeatArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thusday", "Friday", "Saturday"]
//        RepeatArray.allCases.text
    
    static let repeatAdditionalArray = ["Never", "Every day", "Weekend"]
    
//    enum RepeatArray: String, CaseIterable {
//        case Sunday, Monday, Tuesday, Wednesday, Thusday, Friday, Saturday
//    }
}


//extension Array where Element == ModelData.RepeatArray {
//
//    var text: String {
//        return map { $0.rawValue }.joined(separator: " ")
//        switch self {
//        case .Sunday:
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
//}
