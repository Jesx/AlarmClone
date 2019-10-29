//
//  Protocol.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

protocol SetRepeatDelegate: AnyObject {
    func setRepeate (days: [ModelData.DaysOfWeek])
}

protocol LabelSettingDelegate: AnyObject {
    func labelSetting(label: String)
}

protocol RingToneSelectedDelegate: AnyObject {
    func ringToneSelected (index: Int)
}
