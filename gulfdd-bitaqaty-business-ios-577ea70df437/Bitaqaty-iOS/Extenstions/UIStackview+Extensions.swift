//
//  UIStackview+Extensions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(axis:NSLayoutConstraint.Axis, spacing:CGFloat) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func anchorStackView(toView view:UIView, anchorX:NSLayoutXAxisAnchor, equalAnchorX:NSLayoutXAxisAnchor, anchorY:NSLayoutYAxisAnchor, equalAnchorY:NSLayoutYAxisAnchor) {
        view.addSubview(self)
        anchorX.constraint(equalTo: equalAnchorX).isActive = true
        anchorY.constraint(equalTo: equalAnchorY).isActive = true
        
    }
    
}


