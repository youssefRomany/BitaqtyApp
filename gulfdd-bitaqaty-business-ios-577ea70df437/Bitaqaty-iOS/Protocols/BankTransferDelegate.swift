//
//  BankTransferDelegate.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/2/21.
//

import Foundation
protocol BankTransferDelegate: AnyObject {
    func next()
    func previous()
    func startLoading()
    func startLoading(msg: String)
    func stopLoading()
}
