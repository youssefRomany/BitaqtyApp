//
//  SavedAccountsList.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/7/21.
//

import Foundation

struct SavedAccountsList: Codable {
    var errors: [ErrorMessage]? = []
    var savedAccounts: [SavedAccount]? = nil;
}

struct SavedAccount: Codable {
    var resellerBankName: String? = nil
    var resellerBankNameAr: String? = nil
    var resellerBankCountryAr: String? = nil
    var resellerBankCountryEn: String? = nil
    var bankAccountNumber: String? = nil
    private var senderName: String? = nil
    var fromBankId: String? = nil
    var fromCountryId: String? = nil
    var selected: Bool? = nil
    
    func getBankName() -> String {
        if (lang == "en") {
            return resellerBankName ?? resellerBankNameAr ?? ""
        } else {
            return resellerBankNameAr ?? resellerBankName ?? ""
        }
    }
    
    
    func getCountryName() -> String {
        if (lang == "en") {
            return resellerBankCountryEn ?? resellerBankCountryAr ?? ""
        } else {
            return resellerBankCountryAr ?? resellerBankCountryEn ?? ""
        }
    }
    
    func getCountryNameWithBrackets() -> String {
        if (lang == "en") {
            return "(\(resellerBankCountryEn ?? resellerBankCountryAr ?? ""))"
        } else {
            return "(\(resellerBankCountryAr ?? resellerBankCountryEn ?? ""))"
        }
    }
    
    func getBankAccount() -> String {
        return bankAccountNumber ?? ""
    }
    
    func getSenderName() -> String {
        return senderName ?? ""
    }
    
    mutating func setSenderName(value: String) {
        senderName = value
    }
    
    func isSelected() -> Bool {
        return selected ?? false
    }
    
    func getIntCountryId() -> Int? {
        return Int(fromCountryId ?? "")
    }
    
    func getIntBankId() -> Int? {
        return Int(fromBankId ?? "")
    }
}
