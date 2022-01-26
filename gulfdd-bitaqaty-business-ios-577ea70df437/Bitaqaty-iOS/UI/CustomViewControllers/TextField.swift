//
//  TextField.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class TxtSmallReg: UITextField {
    override func awakeFromNib() {
        font = UIFont(name: FONT_REG, size: FONT_SMALL);
    }
}

class TxtMediumReg: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func awakeFromNib() {
        textAlignment = lang == "en" ? .left : .right
        font = UIFont(name: FONT_REG, size: FONT_MEDUIM);
    }
}

class TxtSmallerLightFont: UITextField {
    override func awakeFromNib() {
        font = UIFont(name: FONT_LIGHT, size: FONT_SMALLER);
    }
}
