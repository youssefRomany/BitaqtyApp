//
//  NSMutableAttributedString+Extension.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/8/21.
//

import Foundation
extension NSMutableAttributedString {
    @discardableResult
    func sbs_append(_ image: UIImage, color: UIColor? = nil) -> Self {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attachmentString = NSAttributedString(attachment: attachment)
        if let color = color {
            if #available(iOS 13, *) {} else {
                // On iOS 12 we need to add a character with a foreground color before the image,
                // in order for the image to get a color.
                let colorString = NSMutableAttributedString(string: "\0")
                colorString.addAttributes([.foregroundColor: color], range: NSRange(location: 0, length: colorString.length))
                append(colorString)
            }
            let attributedString = NSMutableAttributedString(attributedString: attachmentString)
            if #available(iOS 13, *) {
                // On iOS 13 we can set the foreground color of the image.
                attributedString.addAttributes([.foregroundColor: color], range: NSRange(location: 0, length: attributedString.length))
            }
            append(attributedString)
        } else {
            append(attachmentString)
        }
        return self
    }
}
