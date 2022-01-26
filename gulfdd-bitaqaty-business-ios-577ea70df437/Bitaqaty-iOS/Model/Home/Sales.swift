//
//  Sales.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 11/10/2021.
//

import Foundation
struct Sales : Codable {
    var amount : String?
    var date : String?
    
    var Amount: Double{
        if amount != nil{
            return (amount as! NSString).doubleValue
        }
        return 0.0
    }
}
