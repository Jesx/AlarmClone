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
        textField.setModifyClearButton()
        
        textField.text = text
        navigationItem.title = "Label"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = textField.text {
            delegate?.labelSetting(label: text)
        }
    }
}
 


