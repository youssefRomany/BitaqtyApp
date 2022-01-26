//
//  CardData.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/25/21.
//

import Foundation
struct CardData: Codable {
    var name: String? = nil
    var number: String? = nil
    var expiryDate: String? = nil
    init(_ name: String,_ number: String, _ expiryDate: String) {
        self.name = name
        self.number = number
        self.expiryDate = expiryDate
    }
}
