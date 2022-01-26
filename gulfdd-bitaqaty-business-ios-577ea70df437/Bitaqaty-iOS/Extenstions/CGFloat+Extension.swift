//
//  CGFloat+Extension.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import Foundation
extension CGFloat{
    static func getStatusBarHeight() -> CGFloat{
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static func getNavBarHeight() -> CGFloat {
        let nav = UINavigationController()
        return nav.navigationBar.frame.size.height
    }
    
    static func getFullWidth() -> CGFloat{
        UIScreen.main.bounds.width
    }
}
