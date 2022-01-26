//
//  Bundle+Extention.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/11/21.
//

import Foundation
import UIKit
private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func set(_ code: String) {
        let bundelCode = "\(code.split(separator: "-")[0])";
        let isLanguageRTL = Locale.characterDirection(forLanguage: bundelCode) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        UserDefaults.standard.setValue(isLanguageRTL,   forKey: UserDefaults.Key.zxtDirection)
        UserDefaults.standard.setValue(isLanguageRTL,   forKey: UserDefaults.Key.writingDirection)
        UserDefaults.standard.setValue([code], forKey: UserDefaults.Key.appleLanguages)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserDefaults.Key.langChanged), object: nil)
    }
}


