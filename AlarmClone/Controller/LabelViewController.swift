//
//  LabelViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

protocol LabelSettingDelegate {
    func labelSetting(label: String)
}


class LabelViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var delegate: LabelSettingDelegate?
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.addLine(position: .LINE_POSITION_TOP, color: .gray, width: 0.5)
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: .gray, width: 0.5)
        
        textField.text = text
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let text = textField.text {
            delegate?.labelSetting(label: text)
        }
    }
}

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
