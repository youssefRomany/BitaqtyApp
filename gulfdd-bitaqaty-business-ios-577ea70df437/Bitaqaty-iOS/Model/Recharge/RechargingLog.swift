//
//  RechargingLog.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/29/21.
//

import Foundation
struct RechargingLog : Codable {
    var errors: [ErrorMessage]? = nil
    
    var id: Int? = 0
    
    var amount: Double? = 0.0
    private var balanceAfter: Double? = 0
    var date: String? = ""
    var chargingMethod: String? = ""
    var chargingMethodAr: String? = ""
    var customerCurrency: String? = ""
    var customerCurrencyAr: String? = ""
    var manualRefillReason: String? = ""
    
    
    var Amount: Double{
        return amount ?? 0.0
    }
    
    var BalanceAfter: Double{
        return balanceAfter ?? 0.0
    }
    
    var RechargeDate: String{
        return date ?? ""
    }
    
    var ManualReason: String{
        return manualRefillReason ?? ""
    }
    var Currency: String{
        if lang == "ar"{
            return customerCurrencyAr ?? ""
        }else{
            return customerCurrency ?? ""
        }
    }
    var ChargingMethod: String{
        if lang == "ar"{
            return chargingMethodAr ?? ""
        }else{
            return chargingMethod ?? ""
        }
    }
}
