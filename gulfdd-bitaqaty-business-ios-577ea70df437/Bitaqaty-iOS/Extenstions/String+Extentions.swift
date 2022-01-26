//
//  String+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func getEnglishNo() -> Double{
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        guard let final = formatter.number(from: self) else { return 0; }
        return Double(truncating: final);
    }
    
    func getArabicNo() -> Double{
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "AR") as Locale
        guard let final = formatter.number(from: self) else { return 0; }
        return Double(truncating: final);
    }
    
    func getStrEnglishNo() -> String{
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        guard let final = formatter.number(from: self) else { return ""; }
        return "\(final)"
    }
    
    func strikeThrough()->NSAttributedString{
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var adjustAlignment: String{
        lang != "en" ? "\u{200F}\(self)" : "\u{200E}\(self)"
    }
    
    public var replacedEnglishDigitsWithArabic: String {
        var str = self
        let map = ["0": "٠",
                   "1": "١",
                   "2": "٢",
                   "3": "٣",
                   "4": "٤",
                   "5": "٥",
                   "6": "٦",
                   "7": "٧",
                   "8": "٨",
                   "9": "٩"]
        if (lang != "en"){
            map.forEach { str = str.replacingOccurrences(of: $0, with: $1) };
        }
        return str
    }
    
    func isEmptyOrContainsOnlySpaces() -> Bool{
        return trimmingCharacters(in: .whitespaces).count == 0;
    }
    
    public var replacedArigitsWithEn: String {
        var str = self
        let map = ["٠":"0",
                   "١":"1",
                   "٢":"2",
                   "٣":"3",
                   "٤":"4",
                   "٥":"5",
                   "٦":"6",
                   "٧":"7",
                   "٨":"8",
                   "٩":"9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) };
        return str
    }
    
    func containNumbers() -> Bool{
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        return decimalRange != nil
    }
    
    func containCapitalLetter() -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func containSmallLetter() -> Bool{
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func isEnglishOnly() -> Bool{
        let regx = "[A-Za-z0-9!#$%&(){|}~:;<=>?@*+,./\\]\\[^_`\\'\\\" \\t\\r\\n\\f-]+"
        let texttest = NSPredicate(format:"SELF MATCHES %@", regx)
        return texttest.evaluate(with: self)
    }
    
    func isEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    var isNotEmpty: Bool{
        return !self.isEmpty
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func withBoldText(boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = lang == "en" ? .left : .right
        style.headIndent = 10
        style.firstLineHeadIndent = 0
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!, NSAttributedString.Key.paragraphStyle: style]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!,NSAttributedString.Key.paragraphStyle: style]
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
}
extension Optional where Wrapped == String{
    var isNilOrEmpty: Bool{
        return self == nil || self!.isEmpty
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(formatted value: Double) {
        var doubleStr = String(format: "%.2f", value) // "3.14"
        if doubleStr.contains(".00"){
            doubleStr = String(format: "%.1f", value) // "3.14"
        }
        appendLiteral(doubleStr)
    }
}
