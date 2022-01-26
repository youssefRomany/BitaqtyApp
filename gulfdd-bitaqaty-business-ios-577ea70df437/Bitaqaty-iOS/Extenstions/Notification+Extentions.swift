//
//  Notification+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let langChanged = Notification.Name("LANG_CHANGED");
    static let tapSelected = Notification.Name("TAP_SELECTED");
    static let rechargeSelected = Notification.Name("RECHARGE_SELECTED");
    static let reloadSubAccountsList = Notification.Name("RELOAD_SUBACCOUNT_LIST");
    static let reloadBalance = Notification.Name("RELOAD_BALANCE");
    static let hideRechargePopup = Notification.Name("HIDE_RECHARGE_POPUP");
    static let reloadTransaction = Notification.Name("RELOAD_TRANSACTION_LOG");
    static let reloadTransactionWithDates = Notification.Name("RELOAD_TRANSACTION_LOG_DATES");
    static let reloadHomeBankRequests = Notification.Name("RELOAD_HOME_BANK_REQUESTS");
    static let reloadHomeRecharge = Notification.Name("RELOAD_HOME_RECHARGE");

}
