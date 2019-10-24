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
open class customUITextField: UITextField {
    
//    func setup() {
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.gray.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width/2, width: self.frame.size.width, height: self.frame.size.height)
//        border.borderWidth = 20
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    let rightViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -386)

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
