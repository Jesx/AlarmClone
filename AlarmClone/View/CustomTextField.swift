//
//  CustomTextField.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class customUITextField: UITextField {

    func setTopBottomLine() {
        let borderWidth = CGFloat(0.5)
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.size.height - borderWidth , width: self.frame.size.width, height: borderWidth)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        self.layer.addSublayer(bottomBorder)
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: -borderWidth , width: self.frame.size.width, height: borderWidth)
        topBorder.backgroundColor = UIColor.gray.cgColor
        self.layer.addSublayer(topBorder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTopBottomLine()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTopBottomLine()
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        //self.frame.size.width/2 - 10
        
        let rightViewPadding = UIEdgeInsets(top: 0, left: self.frame.size.width - 30, bottom: 0, right: 0)
        return bounds.inset(by: rightViewPadding)
    }

}

// MARK: - Add custom clear button
extension UITextField {

    func setModifyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)

        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }

    // When press button clear textfield
    @objc func clear(sender : AnyObject) {
        self.text = ""
    }
}
