//
//  UserInfo.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
class UserInfo: Codable, Copying {
    typealias Prototype = UserInfo // <-- requires adding this line to classes

    required init(instance: UserInfo) {
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Prototype(instance: self)
    }
    
    var id: Int? = 0
    var parentResellerId: Int? = 0
    
    var balance: Double? = 0.0
    var lastLoginDate: Double? = 0
    
    var username: String? = ""
    var customerStatus: String? = ""
    var fullName: String? = ""
    var accountNumber: String? = ""
    var email: String? = ""
    var currencyEn: String? = ""
    var currencyAr: String? = ""
    var mobileNumber: String? = ""
    var accessType: String? = ""
    var authenticationType: String? = ""

    var subAccountDetailsDTO: SubAccountDetail? = nil
    
    var accountExpired: Bool? = false
    var accountLocked: Bool? = false
    var passwordExpired: Bool? = false
    var active: Bool? = false
    var acceptAgreement: Bool? = false
    
    var parentResellerMobileNumber: String? = nil
    var parentResellerEmail: String? = nil
    
    private var permissions : [Permissions]?
    
    
    var LastLoginDate: Double{
        return lastLoginDate ?? 0.0
    }
    
    var AcceptAgreement: Bool{
        return acceptAgreement ?? false
    }
    
    var Username: String{
        return username ?? ""
    }
    var FullName: String{
        return fullName ?? ""
    }
    var Email: String{
        return email ?? ""
    }
    var CurrencyEN: String{
        return currencyEn ?? ""
    }
    
    var Currency: String{
        if lang == "ar"{
            return currencyAr ?? ""
        }else{
            return currencyEn ?? ""
        }
    }
    var Balance: Double{
        return balance != nil ? Double(round(10 * balance!)/10) : 0.0
    }
    var BalanceStr: String{
        return balance != nil ? String(format:"%.1f", balance!) : "0.0"
    }
    var AccessType: String{
        set{
            accessType = newValue
        }
        get{
            return accessType ?? ""
        }
    }
    
    var AccountLocked: Bool{
        set{
            accountLocked = newValue
        }
        get{
            return accountLocked ?? false
        }
    }
    var PermissionsArr: [Permissions]{
        set{
            permissions = newValue
        }
        get{
            return permissions ?? []
        }
    }
    
}
