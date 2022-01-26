//
//  UIDevice+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436;
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var longiPhone: Bool {
        return UIScreen.main.nativeBounds.height == 2436 || UIScreen.main.nativeBounds.height == 2688 || UIScreen.main.nativeBounds.height == 1792;
    }
    var isSmall: Bool {
        return UIScreen.main.nativeBounds.height == 1136 || UIScreen.main.nativeBounds.height == 960
    }
    var isSmallAnd7: Bool {
        return UIScreen.main.nativeBounds.height == 1136 || UIScreen.main.nativeBounds.height == 960  || UIScreen.main.nativeBounds.height == 1334
    }
    static var isPad: Bool{
        self.current.userInterfaceIdiom == .pad
    }
    enum ScreenType: String {
        case iPhone4_4S = "small"
        case iPhones_5_5s_5c_SE = "small2"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhoneX"
        case MAX = "MAX"
        case XR = "iPhoneXR"
        
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2688:
            return .MAX
        case 2436:
            return .iPhoneX
        case 1792:
            return .XR
        default:
            return .unknown
        }
    }
}

