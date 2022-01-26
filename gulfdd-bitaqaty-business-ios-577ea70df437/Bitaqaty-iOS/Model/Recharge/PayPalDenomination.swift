//
//  PayPalDenomination.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/2/21.
//

import Foundation
struct PayPalDenomination : Codable {
    private var id : Int?
    private var  amount : Double?
    private var  resellerPrice : Double?
    private var  customerPrice : Double?
    private var  logo : String?
    
    var Amount: Double{
        return amount ?? 0.0
    }
    var ResellerPrice: Double{
        return resellerPrice ?? 0.0
    }
    var Logo: String{
        return logo ?? ""
    }
    var Id: Int{
        return id ?? 0
    }
}
