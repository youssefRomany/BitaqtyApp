//
//  UIFont+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var lightSmaller: UIFont {
        return UIFont(name: FONT_LIGHT, size: FONT_SMALLER)!;
    }
    static var lightMedium: UIFont {
        return UIFont(name: FONT_LIGHT, size: FONT_MEDUIM)!;
    }
    static var regularSmaller: UIFont {
        return UIFont(name: FONT_REG, size: FONT_SMALLER)!;
    }
    static var regularSmall: UIFont {
        return UIFont(name: FONT_REG, size: FONT_SMALL)!;
    }
    
    static var regularMedium: UIFont {
        return UIFont(name: FONT_REG, size: FONT_MEDUIM)!;
    }
    
    static var regularLarge: UIFont {
        return UIFont(name: FONT_REG, size: FONT_LARGE)!;
    }

    static var boldSmall: UIFont {
        return UIFont(name: FONT_BOLD, size: FONT_SMALL)!;
    }
    
    static var boldMedium: UIFont {
        return UIFont(name: FONT_BOLD, size: FONT_MEDUIM)!;
    }
    
    static var boldLarge: UIFont {
        return UIFont(name: FONT_BOLD, size: FONT_LARGE)!;
    }

    static var semiBoldSmall: UIFont {
        return UIFont(name: FONT_SEMI_BOLD, size: FONT_SMALL)!;
    }
    
    static var semiBoldMedium: UIFont {
        return UIFont(name: FONT_SEMI_BOLD, size: FONT_MEDUIM)!;
    }
    
    static var semiBoldLarge: UIFont {
        return UIFont(name: FONT_SEMI_BOLD, size: FONT_LARGE)!;
    }
}

