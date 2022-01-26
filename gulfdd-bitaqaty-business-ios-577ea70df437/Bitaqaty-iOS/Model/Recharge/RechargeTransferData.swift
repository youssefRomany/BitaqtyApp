//
//  RechargeTransferData.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/16/21.
//

import Foundation
class RechargeTransferData: Codable  {
        var chargingMethodDTO: RechargeMethod!
        var chargeAmount: Double!
        var payPalDenominationDto: PayPalDenomination?
    
    init(method:RechargeMethod , amount: Double ) {
        chargingMethodDTO = method
        chargeAmount = amount
    }
    var PayPalDenominationDto: PayPalDenomination?{
        set{
            payPalDenominationDto = newValue
        }
        get{
            return payPalDenominationDto ?? nil
        }
    }
//    var ChargeAmount: Double{
//        set{
//            chargeAmount = newValue
//        }
//        get{
//            return chargeAmount ?? 0.0
//        }
//    }
}
