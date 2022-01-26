//
//  PaymentStatusRequest.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/18/21.
//

import Foundation
class PaymentStatusRequest: Codable  {
    var checkoutId: String!
    var chargingCode: String!
    var chargingMethodDisciminatorValue: String!
    var chargeAmount: String!
    var chargingMethodDTO: RechargeMethod!
    var payPalDenominationDto: PayPalDenomination!
    
    init(method:RechargeMethod, amount: String, checkoutId: String,disciminatorValue: String,chargingCode: String) {
        self.chargingMethodDTO = method
        self.chargeAmount = amount
        self.checkoutId = checkoutId
        self.chargingMethodDisciminatorValue = disciminatorValue
        self.chargingCode = chargingCode
    }
    
    var PayPalDenominationDto: PayPalDenomination?{
        set{
            payPalDenominationDto = newValue
        }
        get{
            return payPalDenominationDto ?? nil
        }
    }
}
