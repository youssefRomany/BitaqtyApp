//
//  ReportRequestBody.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import Foundation

struct ReportRequestBody: Codable {
    var pageSize = PAGE_SIZE
    var pageNumber: Int = 1
    var subAccountId: Int? = nil
    var categoryId: Int? = nil
    var merchantId: Int? = nil
    var productId: Int? = nil
    var searchPeriod: String? = DATE.CURRENT_MONTH.rawValue
    var customDateFrom: String? = nil
    var customDateTo: String? = nil
    var channel: String? = nil
}
