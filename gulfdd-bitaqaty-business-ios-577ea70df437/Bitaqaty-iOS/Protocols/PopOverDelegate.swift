//
//  PopOverDelegate.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/29/21.
//

import Foundation
protocol PopOverDelegate: AnyObject {
    func getPosition(_ type: Int,_ position: Int,_ popType: Int);
    func getDate(_ type: Int,_ date: Date);
}
