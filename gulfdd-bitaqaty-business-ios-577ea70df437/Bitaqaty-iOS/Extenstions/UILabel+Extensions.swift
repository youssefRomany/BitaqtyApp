//
//  UILabel+Extensions.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/11/21.
//

import Foundation
extension UILabel {
   func underline() {
    
    guard let tittleText = self.text else { return }
    let attributedString = NSMutableAttributedString(string: (tittleText))
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
    self.attributedText = attributedString
}
    func setMargins(_ margin: CGFloat = 5) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }

}
