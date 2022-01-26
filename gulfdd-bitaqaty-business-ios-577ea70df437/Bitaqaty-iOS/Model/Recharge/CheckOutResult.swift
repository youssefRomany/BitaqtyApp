//
//  CheckOutResult.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/16/21.
//

import Foundation
struct CheckOutResult: Codable  {
    var errors: [ErrorMessage]?
    private var checkoutId: String?
    var CheckoutId: String{
        return checkoutId ?? ""
    }
}
