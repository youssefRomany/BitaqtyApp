//
//  UIColor+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var primary: UIColor {
        return UIColor(named: "ColorPrimary")!
    }
    
    static var lightGray: UIColor {
        return UIColor(named: "ColorLightGray")!
    }

    
    static var bgColor : UIColor{
        return UIColor(named: "ColorBackground")!
    }
    
    static var textColor : UIColor{
        return UIColor(named: "ColorText")!
    }
    
    static var shadow: UIColor{
        return UIColor(named: "ColorShadow")!
    }
    static var accentColor: UIColor{
        return UIColor(named: "ColorAccent")!
    }
    static var secondryColor: UIColor{
        return UIColor(named: "ColorSecondaryText")!
    }
    
    static var borderColor: UIColor{
        return UIColor(named: "ColorBorder")!
    }
    
    static var darkYellowColor: UIColor{
        return UIColor(named: "ColorDarkYellow")!
    }
    
    static var lightBorderColor: UIColor{
        return UIColor(named: "ColorLightBorder")!
    }
    
    
    static var txtGray: UIColor{
        return fromString("#D3CEDF");
    }
    
    static var lighterBG: UIColor{
        return fromString("#FAFAFA");
    }
    
    static var colorInvalid: UIColor{
        return fromString("#B6003B")
    }
    
    static var colorValid: UIColor{
        return fromString("#008A63")
    }
    
   

    
    var name: String {
        var name = self.description.replacingOccurrences(of: "NamedColor(name: \"", with: "")
        name = name.replacingOccurrences(of: "\", bundle: nil)", with: "")
        return name
    }
    
    
    static func fromString (_ hex: String) -> UIColor{
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
