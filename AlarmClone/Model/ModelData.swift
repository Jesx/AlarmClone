//
//  ModelData.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

enum AlarmDetailDataSource {
    static let ringTone = ["Rain Drops","Silk", "Slow Rise", "Snowman Frozen", "Whistle"]
    
    static let repeatStatus: [(fullName: String, shortName: String, isSelected: Bool)] = [
        (fullName: "Every Sunday", shortName: "Sun", isSelected: false),
        (fullName: "Every Monday", shortName: "Mon", isSelected: false),
        (fullName: "Every Tuesday", shortName: "Tue", isSelected: false),
        (fullName: "Every Wednesday", shortName: "Wed", isSelected: false),
        (fullName: "Every Thusday", shortName: "Thu", isSelected: false),
        (fullName: "Every Friday", shortName: "Fri", isSelected: false),
        (fullName: "Every Sunday", shortName: "Sun", isSelected: false)
    ]
}
