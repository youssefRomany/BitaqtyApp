//
//  TransactionLogResult.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/21/21.
//

import Foundation
struct TransactionLogResult: Codable {
    var transactionLogList : [TransactionLog]?
    let totalElementsCount : Int?
    var errors: [ErrorMessage]? = nil
    
    var TranscationList: [TransactionLog]{
        return transactionLogList ?? []
    }
    
}
