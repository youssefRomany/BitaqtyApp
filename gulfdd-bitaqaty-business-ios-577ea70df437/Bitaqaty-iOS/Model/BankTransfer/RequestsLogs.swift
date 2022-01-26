//
//  RequestsLogs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/29/21.
//

import Foundation

struct RequestsLogs: Codable {
    var errors: [ErrorMessage]? = nil
    var requestsLogs: [RequestLog]? = nil
    var requestTotalCount: Int? = 0
    
    
    init(error: ErrorMessage) {
        errors = [error]
    }
}

struct RequestLog: Codable {
    private var creationDate: String?
    private var transferDate: String?
    private var transferPersonName: String?
    private var bankNameEn: String?
    private var bankNameAr: String?
    private var amount: String?
    private var status: String?
    private var rejectionReason: String?
    private var currencyAr: String?
    private var currencyEn: String?
    
    func getCreationDate()-> String {
        return creationDate ?? ""
    }
    
    func getTransferDate()-> String {
        return transferDate ?? ""
    }
    
    func getTransferPersonName()-> String {
        return transferPersonName ?? ""
    }
    
    func getCurrentBankName()-> String {
        if (lang == "en") {
            return bankNameEn ?? bankNameAr ?? ""
        } else {
            return bankNameAr ?? bankNameEn ?? ""
        }
    }
    
    func getAmount()-> String {
        return amount ?? ""
    }
    
    func getStatus()-> String {
        return status ?? ""
    }
    func getStatusName()-> String {
        switch status?.lowercased(){
        case BankTransferStatus.ACCEPTED.rawValue:
            return btrrStrings.btrr_status_accepted.localizedValue
        case BankTransferStatus.REJECTED.rawValue:
            return btrrStrings.btrr_status_rejected.localizedValue
        default:
            return btrrStrings.btrr_status_pending.localizedValue
        }
    }
    
    func getRejectionReason()-> String {
        return rejectionReason ?? ""
    }
    
    func getCurrentCurrency()-> String {
        if (lang == "en") {
            return currencyEn ?? currencyAr ?? ""
        } else {
            return currencyAr ?? currencyEn ?? ""
        }
    }
}
struct RequestLogBody: Codable {
    var pageSize: Int = PAGE_SIZE
    var pageNumber: Int = 1
    var dateFrom: String? = nil
    var dateTo: String? = nil
    var requestStatus: String = BankTransferStatus.ALL.rawValue
}
