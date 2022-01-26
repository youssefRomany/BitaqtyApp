//
//  Constants.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import AVFoundation

let STORE_URL = "http://onelink.to/jb4zd2";

let MEDIA_URL = "\(API.BASE_URL)";

let APP_LANG = "AppleLanguages";

let SHADOW_COLOR: CGFloat = 50 / 255.0;
var lang = "en";
var isReset = false;
var isDrawerOPened = false;
var LanguageChanging = false;
typealias DownloadComplete = () -> ();
var MORE_PERMISSIONS: [Int] = []
let PAGE_SIZE: Int = 10
var SETTINGS: [SystemSettings] = []
// FONT NAME
let enBold = "Roboto-Bold";
let enSemiBold = "Roboto-Medium";
let enReg = "Roboto-Regular";
let enLight = "Roboto-Light";

let arReg = "Tajawal-Regular";
let arSemiBold = "Tajawal-Medium";
let arBold = "Tajawal-Bold";
let arLight = "Tajawal-Light";

let FONT_ICON = "FontAwesome5Free-Solid"
var FONT_LIGHT = lang == "en" ? enLight : arLight;
var FONT_BOLD = lang == "en" ? enBold : arBold;
var FONT_REG = lang == "en" ? enReg: arReg;
var FONT_SEMI_BOLD = lang == "en" ? enSemiBold: arSemiBold;
// FONT SIZE


var FONT_SMALLER: CGFloat = FontSize.Smaller.size
var FONT_SMALL: CGFloat = FontSize.Small.size
var FONT_MEDUIM: CGFloat = FontSize.Medium.size
var FONT_LARGE: CGFloat = FontSize.Large.size
var FONT_LARGER: CGFloat = FontSize.Larger.size

var ICON_FONT_SMALL: CGFloat = UIDevice.isPad ? 20 : 15
var ICON_FONT_MEDUIM: CGFloat = UIDevice.isPad ? 25 : 20
var ICON_FONT_LARGE: CGFloat = UIDevice.isPad ? 30 : 25

let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15);

let USER_DATA = "USER_DATA";
let LOGIN_TOKEN = "LOGIN_TOKEN";
let TOUR_SETTING = "TOUR_SETTING";
let CURRENT_TOKEN = "CURRENT_TOKEN";

let imageCache = AutoPurgingImageCache(
    memoryCapacity: 900 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 600 * 1024 * 1024
)
extension UserDefaults{
    enum Key {
        static let appleLanguages = "AppleLanguages"
        static let zxtDirection = "AppleTe  zxtDirection"
        static let writingDirection = "NSForceRightToLeftWritingDirection"
        static let langChanged = "LangChanged"
        static let userData = "USER_DATA"
        static let token = "CURRENT_TOKEN"
        static let sessionEnded = "SESSION_ENDED"
        static let settings = "APP_SETTINGS"
        static let currency = "CURRENCY"
        static let installedBefore = "INSTALLED_BEFORE"
        static let simpleSearchResults = "SIMPLE_RESULTS"
        static let darkModeSettings = "DARK_MODE"
        static let wishListItems = "WISH_LIST"
        static let cartListItems = "CART_LIST"
        static let FIRST_INSTALL = "FIRST_INSTALL"
        static let USER_NAME = "USER_NAME"
    }
}
