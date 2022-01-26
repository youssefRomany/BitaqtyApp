//
//  TransferAmount.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/16/21.
//

import Foundation
struct TransferAmount: Codable  {
    private var amountAfterFees, feesAmount: String?
    var errors: [ErrorMessage]?

    var AmountAfter: String{
        if amountAfterFees != nil && !amountAfterFees!.isEmpty{
            let pi = Double(amountAfterFees!)
            return  String(format:"%.2f", pi!)
        }
        return ""
    }
}
