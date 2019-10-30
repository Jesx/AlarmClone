//
//  AlarmTableViewCell.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/22.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var repeatStatusLabel: UILabel!
    
    let onOffSwitch = UISwitch()
    let tailImageView = UIImageView(image: UIImage(named: "Forward_Filled"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onOffSwitch.isOn = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
