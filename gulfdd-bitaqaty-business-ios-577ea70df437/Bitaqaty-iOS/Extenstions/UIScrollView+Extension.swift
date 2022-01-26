//
//  UIScrollView+Extension.swift
//  Zillo
//
//  Created by Noura on 4/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func snapshot() -> UIImage?{
        UIGraphicsBeginImageContext(self.contentSize)
        
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame
        
        self.contentOffset = CGPoint.zero
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        return image
    }
    func createImage() -> UIImage{
        
        print("contentSize.height \(contentSize.height) = \(UIScreen.main.bounds.size.height)")
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        // save the orginal offset & frame
        let savedContentOffset = contentOffset
        let savedFrame = frame
        // end ctx, restore offset & frame before returning
        defer {
            UIGraphicsEndImageContext()
            contentOffset = savedContentOffset
            frame = savedFrame
        }
        // change the offset & frame so as to include all content
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return UIImage();
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }
}
