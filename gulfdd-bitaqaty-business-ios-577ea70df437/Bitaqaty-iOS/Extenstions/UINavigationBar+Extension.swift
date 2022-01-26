//
//  UINavigationBar+Extension.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/22/21.
//

import Foundation
import UIKit

extension UINavigationBar {
    var castShadow : String {
        get { return "anything fake" }
        set {
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowRadius = 3.0
            self.layer.shadowColor = UIColor.red.cgColor
            self.layer.shadowOpacity = 0.7
        }
    }
    
}
