//
//  ManageSubAccountDelegate.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/28/21.
//

import Foundation
protocol ManageSubAccountDelegate: class {
    func onManage(index: Int)
    func onTransactionLog(index: Int)
}
