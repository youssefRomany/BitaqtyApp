//
//  RechargingLogResult.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/29/21.
//

import Foundation
struct RechargingLogResult : Codable {
    let resultList : [RechargingLog]?
    let totalElementsCount : Int?
    var errors: [ErrorMessage]? = nil
}
