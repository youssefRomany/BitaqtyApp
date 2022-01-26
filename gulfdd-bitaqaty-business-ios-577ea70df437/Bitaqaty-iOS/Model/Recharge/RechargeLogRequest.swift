//
//  RechargeLogRequest.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/7/21.
//

import Foundation
struct RechargeLogRequest: Codable {
    var pageSize: Int = PAGE_SIZE
    var pageNumber: Int = 1
    var customerId: Int = 0
    var discriminatorValue: String? = nil
    var dateFrom: String? = nil
    var dateTo: String? = nil
}
