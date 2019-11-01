//
//  LabelViewController.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: LabelSettingDelegate?
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.setModifyClearButton()
        textField.enablesReturnKeyAutomatically = true
        
        textField.text = text

        textField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = textField.text, !text.isEmpty {
            delegate?.labelSetting(label: text)
        }
    }
}

extension LabelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            delegate?.labelSetting(label: text)
        }
        navigationController?.popViewController(animated: true)
        return true
    }
}
