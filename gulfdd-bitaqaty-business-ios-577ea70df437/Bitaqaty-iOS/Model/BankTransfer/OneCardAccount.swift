//
//  OneCardAccount.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/2/21.
//

import Foundation
struct OneCardAccount: Codable {
    var errors: [ErrorMessage]? = []
    var accounts: [Account]? = nil;
}

struct Account: Codable {
    var oneCardBankAccountId: String? = nil
    private var oneCardBankNameAr: String? = nil
    private var oneCardBankNameEn: String? = nil
    var oneCardBankLogoPath: String? = nil
    private var oneCardAccountNumber: String? = nil
    private var oneCardAccountNameAr: String? = nil
    private var oneCardAccountNameEn: String? = nil
    private var oneCardBankAddresssAr: String? = nil
    private var oneCardBankAddresssEn: String? = nil
    private var oneCardBankIban: String? = nil
    private var oneCardBankAccountCurrencyAr: String? = nil
    private var oneCardBankAccountCurrencyEn: String? = nil
    var refNumberIsMandatory: Bool? = false
    
    func getBankName()-> String {
        if (lang == "en") {
            return oneCardBankNameEn ?? oneCardBankNameAr ?? ""
        } else {
            return oneCardBankNameAr ?? oneCardBankNameEn ?? ""
        }
    }
    
    func getAccountNumber()-> String {
        return oneCardAccountNumber ?? ""
    }
    
    func getAccountName()-> String {
        if (lang == "en") {
            return oneCardAccountNameEn ?? oneCardAccountNameAr ?? ""
        } else {
            return oneCardAccountNameAr ?? oneCardAccountNameEn ?? ""
        }
    }
    
    func getAccountAddress()-> String {
        if (lang == "en") {
            return oneCardBankAddresssEn ?? oneCardBankAddresssAr ?? ""
        } else {
            return oneCardBankAddresssAr ?? oneCardBankAddresssEn ?? ""
        }
    }
    
    func getIban()-> String {
        return oneCardBankIban ?? ""
    }
    
    func getCurrency()-> String? {
        if (lang == "en") {
            return oneCardBankAccountCurrencyEn ?? oneCardBankAccountCurrencyAr ?? ""
        } else {
            return oneCardBankAccountCurrencyAr ?? oneCardBankAccountCurrencyEn ?? ""
        }
    }
}
struct RequestOneCardAccountsBody: Codable {
    var resellerUsername: String
    var countryId: Int?
    var pageSize: Int = 1000
    var pageNumber: Int = 1
    
    init(resellerUsername: String, countryId: Int? = nil) {
        self.resellerUsername = resellerUsername
        self.countryId = countryId
    }
}
