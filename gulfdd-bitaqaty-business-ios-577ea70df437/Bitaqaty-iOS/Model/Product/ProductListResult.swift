//
//  ProductListResult.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import Foundation
struct ProductListResult: Codable {
    var errors: [ErrorMessage]? = nil
    var products : [Product]?
    var totalElementsCount : Int?
    var disabledMerchant : Bool?
    var productArr: [Product]{
        set{
            products = newValue
        }
        get{
            return products ?? []
        }
    }
}
