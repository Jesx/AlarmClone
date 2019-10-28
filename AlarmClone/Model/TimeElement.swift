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
    var timeString: String
    var time: Date
    var textLabel: String
    var ringTone: String
    var repeatStatus: String
    var isOn: Bool
}
