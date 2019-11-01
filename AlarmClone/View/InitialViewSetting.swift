//
//  InitialViewSetting.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/31.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

class InitialViewSetting {
    
    static func mainViewChange(_ vc: AlarmViewController) {
        if vc.alarmArray.count == 0 {
            vc.tableView.isHidden = true
            vc.textLabel.isHidden = false
        } else {
            vc.tableView.isHidden = false
            vc.textLabel.isHidden = true
        }
    }
}
