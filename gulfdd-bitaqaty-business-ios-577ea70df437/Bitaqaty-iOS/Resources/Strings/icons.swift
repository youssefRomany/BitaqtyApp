//
//  icons.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
enum icons: String{
    
    case ic_hide = "\u{f070}";
    case ic_show = "\u{f06e}";
    case ic_error = "\u{f06a}";
    case ic_correct = "\u{f00c}";
    case ic_arrow_r = "\u{f105}";
    case ic_arrow_l = "\u{f053}";
    case ic_arrow_down = "\u{f107}";
    
    var localizedValue: String{
        switch self {
        case .ic_hide:
            return self.rawValue
        case .ic_show:
            return self.rawValue
        case .ic_error:
            return self.rawValue
        case .ic_correct:
            return self.rawValue
        case .ic_arrow_down:
            return self.rawValue
        case .ic_arrow_r:
            if (lang != "en"){
                return "\u{f104}"
            }
            return self.rawValue
        case .ic_arrow_l:
            if (lang != "en"){
                return "\u{f105}"
            }
            return self.rawValue
        }
    }
}
