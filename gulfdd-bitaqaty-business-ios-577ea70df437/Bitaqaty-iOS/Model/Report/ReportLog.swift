//
//  ReportLog.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import Foundation

struct ReportLog: Codable {
    
    var errors: [ErrorMessage]? = nil
    var elements: [Report]? = nil
    var totalElementsCount: Int? = nil
    var transactionsTotalAmount: Double? = nil
    var transactionsTotalAmountForRecommendedPrice: Double? = nil
    var numberOfTransactions: Int = 0
    var totalRecommendedPrice: Double? = nil
    var totalExpectedProfit: Double? = nil
    var transactionsTotalAmountForSubResellerPrice: Double? = nil
    var totalSubResellerPrice: Double? = nil
    var totalProfit: Double? = nil

}

