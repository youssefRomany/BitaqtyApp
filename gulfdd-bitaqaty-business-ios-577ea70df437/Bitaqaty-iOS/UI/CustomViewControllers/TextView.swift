//
//  TextView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/17/21.
//

import UIKit

class TextView: UITextView {
    
    override func awakeFromNib() {
        textAlignment = lang == "en" ? .left : .right
        font = UIFont(name: FONT_REG, size: FONT_MEDUIM);
    }
}
