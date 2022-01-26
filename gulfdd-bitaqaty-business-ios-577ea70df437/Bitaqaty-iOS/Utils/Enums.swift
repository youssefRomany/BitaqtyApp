//
//  Enums.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/22/21.
//

import Foundation
enum FontSize: Int {
    case Smaller = 0
    case Small = 1
    case Medium = 2
    case Large = 3
    case Larger = 4
    var size: CGFloat{
        switch self {
        case .Smaller:
            return UIDevice.current.userInterfaceIdiom == .pad ? 15 : 10
        case .Small:
            return UIDevice.current.userInterfaceIdiom == .pad ? 20 : 12
        case .Medium:
            return UIDevice.current.userInterfaceIdiom == .pad ? lang == "en" ? 24 : 16 : lang == "en" ? 16 : 14
        case .Large:
            return UIDevice.current.userInterfaceIdiom == .pad ? lang == "en" ? 23 : 20 : lang == "en" ? 20 : 18
        case .Larger:
            return UIDevice.current.userInterfaceIdiom == .pad ? lang == "en" ? 33 : 25 : lang == "en" ? 30 : 30
        }
    }
}
enum VerticalLocation: String {
    case bottom
    case top
}
enum Accounts: Int {
    case MASTER_ACCOUNT
    case SUB_ACCOUNT
}
enum RechargeTypes: Int {
    case Bank = 0
    case Mada = 1
    case Credit = 2
    case Amex = 3
    case PayPal = 4
    var brandName: String{
        switch self {
        case .Credit:
            return "VISA"
        case .PayPal:
            return "PAYPAL"
        case .Amex:
            return "AMEX"
        case .Bank:
            return ""
        case .Mada:
            return "MADA"
        }
    }
    var brandTitle: String{
        switch self {
        case .Credit:
            return "Visa"
        case .PayPal:
            return "PayPal"
        case .Amex:
            return "American Express"
        case .Bank:
            return ""
        case .Mada:
            return "Mada"
        }
    }
}

enum ChangePasswordType: Int {
    case normal
    case login
}

enum Validation: Int {
    case normal
    case valid
    case invalid
}


enum AlertType: Int {
    case none
    case warning
    case success
}
enum Roles: String {
    case MASTER_ACCOUNT = "MASTER_ACCOUNT"
    case SUB_ACCOUNT = "SUB_ACCOUNT"
}

enum SUB_ACCOUNT_TYPE: String {
    case LIMIT = "LIMIT"
    case NO_LIMIT = "NO_LIMIT"
    case PERIODIC_LIMIT = "PERIODICAL_LIMIT"
    var title: String{
        switch self {
        case .LIMIT:
            return manageStrings.limit.localizedValue
        case .PERIODIC_LIMIT:
            return manageStrings.periodic.localizedValue
        case .NO_LIMIT:
            return manageStrings.notLimited.localizedValue
        }
    }
}
enum ErrorType: Int {
    case Network
    case Server
    case Unknown
    case Empty
    case Auth
}
enum POPUP_TYPE: Int {
    case RECHARGE_METHODS
    case CATEGORIES
    case SERVICES
    case USERS
    case CHANNEL
    case PRINTED
}

enum ACCESS_TYPE: String {
    case DEFAULT = "DEFAULT"
    case WEBSITE = "WEBSITE"
    case APPLICATION = "APPLICATION"
    var title: String{
        switch self {
        case .DEFAULT:
            return manageStrings.DEFAULT.localizedValue
        case .WEBSITE:
            return manageStrings.web.localizedValue
        case .APPLICATION:
            return manageStrings.application.localizedValue
        }
    }
}
enum SUB_DURATION_TYPE: String {
    case DAILY = "DAILY"
    case WEEKLY = "WEEKLY"
    case MONTHLY = "MONTHLY"
    var title: String{
        switch self {
        case .DAILY:
            return manageStrings.daily.localizedValue
        case .WEEKLY:
            return manageStrings.weekly.localizedValue
        case .MONTHLY:
            return manageStrings.monthly.localizedValue
        }
    }
}
enum PERMISSIONS_IDS: Int {
    case PURCHASE = 1
    case VIEW_PURCHASE_LIMIT = 2
    case VIEW_MASTER_BALANCE = 3
    case VIEW_PRODUCT_DISCOUNT = 4
    case RECHARGE = 5
    case VIEW_TRANSACTION_LOG = 6
    case VIEW_PRODUCT_LIST = 7
    case VIEW_REPORTS = 8
    case VIEW_SUPPORT_CENTER = 9
}
enum CHILD_RECHARGE_PERMISSIONS_IDS: Int {
    case RECHARGE_LOG = 10
    case CHOOSE_RECHARGE_LOG = 11
    case BANK = 12
    case MADA = 13
    case CREDIT = 14
    case AMEX = 15
    case PAYPAL = 16
    var type: Int{
        switch self {
        case .CREDIT:
            return RechargeTypes.Credit.rawValue
        case .PAYPAL:
            return RechargeTypes.PayPal.rawValue
        case .AMEX:
            return RechargeTypes.Amex.rawValue
        case .BANK:
            return RechargeTypes.Bank.rawValue
        case .MADA:
            return RechargeTypes.Mada.rawValue
        default:
            return -1
        }
    }
}

enum CHILD_TRANSACTION_PERMISSIONS_IDS: Int {
    case CHOOSE_TRANSACTION_LOG = 17
    case ACCOUNT_ONLY = 18
    case ALL_SUB_ACCOUNTS = 19
}

enum CHILD_REPORTS_PERMISSIONS_IDS: Int {
    case CHOOSE_REPORTS = 20
    case ACCOUNT_ONLY = 21
    case ALL_ACCOUNTS = 22
}

enum SUBACCOUNT_TABS: Int {
    case HOME = 1
    case STORE = 2
    case RECHARGE = 3
    case TRANSACTION_LOG = 4
    case REPORTS = 5
    case SUPPORT = 6
    case MORE = 7
    case PRODUCT_LIST = 8
}
enum ImageType: Int {
    case Radio = 0
    case CheckBox = 1
}

enum RECHARGE_METHODS: String {
    case CREDIT_CARD = "CREDIT_CARD"
    case PAYPAL = "PAYPAL"
    case AMEX = "AMEX"
    case BANK_TRANSFER = "BANK_TRANSFER"
    case MADA = "MADA"
    
    var title: String{
        switch self {
        case .CREDIT_CARD:
            return strings.credit.localizedValue
        case .PAYPAL:
            return strings.paypal.localizedValue
        case .AMEX:
            return strings.amex.localizedValue
        case .BANK_TRANSFER:
            return strings.bankTransfer.localizedValue
        case .MADA:
            return strings.mada.localizedValue
        }
    }
    var type: Int{
        switch self {
        case .CREDIT_CARD:
            return RechargeTypes.Credit.rawValue
        case .PAYPAL:
            return RechargeTypes.PayPal.rawValue
        case .AMEX:
            return RechargeTypes.Amex.rawValue
        case .BANK_TRANSFER:
            return RechargeTypes.Bank.rawValue
        case .MADA:
            return RechargeTypes.Mada.rawValue
        }
    }
}

enum SETTING_KEYS: String {
    case SEARCH_SUBACCOUNT_KEYWORD_MIN_LENGTH = "SEARCH_SUBACCOUNT_KEYWORD_MIN_LENGTH"
    
    case CREDIT_CARD_NUMBER_OF_REQUESTS_PER_DAY = "CREDIT_CARD_NUMBER_OF_REQUESTS_PER_DAY"
    case CREDIT_CARD_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY = "CREDIT_CARD_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY"
    case CREDIT_CARD_MAXIMUM_AMOUNT_PER_REQUEST = "CREDIT_CARD_MAXIMUM_AMOUNT_PER_REQUEST"
    case CREDIT_CARD_MINIMUM_AMOUNT_PER_REQUEST = "CREDIT_CARD_MINIMUM_AMOUNT_PER_REQUEST"
    
    case BANK_TRANSFER_NUMBER_OF_REQUESTS_PER_DAY = "BANK_TRANSFER_NUMBER_OF_REQUESTS_PER_DAY"
    case BANK_TRANSFER_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY = "BANK_TRANSFER_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY"
    case BANK_TRANSFER_MAXIMUM_AMOUNT_PER_REQUEST = "BANK_TRANSFER_MAXIMUM_AMOUNT_PER_REQUEST"
    case BANK_TRANSFER_MINIMUM_AMOUNT_PER_REQUEST = "BANK_TRANSFER_MINIMUM_AMOUNT_PER_REQUEST"
    case MADA_NUMBER_OF_REQUESTS_PER_DAY = "MADA_NUMBER_OF_REQUESTS_PER_DAY"
    case MADA_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY = "MADA_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY"
    case MADA_MAXIMUM_AMOUNT_PER_REQUEST = "MADA_MAXIMUM_AMOUNT_PER_REQUEST"
    case MADA_MINIMUM_AMOUNT_PER_REQUEST = "MADA_MINIMUM_AMOUNT_PER_REQUEST"
    case AMEX_NUMBER_OF_REQUESTS_PER_DAY = "AMEX_NUMBER_OF_REQUESTS_PER_DAY"
    case AMEX_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY = "AMEX_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY"
    case AMEX_MAXIMUM_AMOUNT_PER_REQUEST = "AMEX_MAXIMUM_AMOUNT_PER_REQUEST"
    case AMEX_MINIMUM_AMOUNT_PER_REQUEST = "AMEX_MINIMUM_AMOUNT_PER_REQUEST"
    case PAYPAL_NUMBER_OF_REQUESTS_PER_DAY = "PAYPAL_NUMBER_OF_REQUESTS_PER_DAY"
    case PAYPAL_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY = "PAYPAL_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY"
    case HYPERPAY_SAVE_CARD_INFO = "HYPERPAY_SAVE_CARD_INFO"
    case MINIMUM_NUMBER_OF_HOME_MERCHANTS = "MINIMUM_NUMBER_OF_HOME_MERCHANTS"
    case MAXIMUM_NUMBER_OF_HOME_MERCHANTS = "MAXIMUM_NUMBER_OF_HOME_MERCHANTS"
    case NOTIFICATIONS_MAX_COUNT = "NOTIFICATIONS_MAX_COUNT"
    
}

enum ERROR_CODES: String {
    case SELECT_RECHARGE_METHOD = "57"
    case NUMBER_OF_REQUESTS_PER_DAY = "58"
    case TOTAL_AMOUNT_OF_REQUESTS_PER_DAY = "59"
    case MIN_AMOUNT_PER_REQUESTS = "60"
    case MAX_AMOUNT_PER_REQUESTS = "61"
    case MAX_REQUEST_PER_DAY = "62"
    case ERROR_RECHARGE_LOG_PERMISSION = "96"
    case NO_PERMISSION_FOR_TRANSACTION_LOG = "104"
    case NO_PERMISSION_FOR_PRODUCT_LIST = "999"
    var message: String{
        switch self {
        case .SELECT_RECHARGE_METHOD:
            return manageStrings.errorRechargePermission.localizedValue
        case .MIN_AMOUNT_PER_REQUESTS:
            return RechargeStrings.minAmount.localizedValue
        case .MAX_AMOUNT_PER_REQUESTS:
            return RechargeStrings.maxAmount.localizedValue
        case .TOTAL_AMOUNT_OF_REQUESTS_PER_DAY:
            return RechargeStrings.errAmoutPerDay.localizedValue
        case .MAX_REQUEST_PER_DAY:
            return RechargeStrings.errRequestPerDay.localizedValue
        case .NUMBER_OF_REQUESTS_PER_DAY:
            return RechargeStrings.errRequestPerDay.localizedValue
        case .ERROR_RECHARGE_LOG_PERMISSION, .NO_PERMISSION_FOR_TRANSACTION_LOG, .NO_PERMISSION_FOR_PRODUCT_LIST:
            return strings.noPermission.localizedValue
        }
        
    }
}

enum BankTransferStatus: String {
    case ALL = "all"
    case PENDING = "pending"
    case ACCEPTED = "accepted"
    case REJECTED = "rejected"
}
enum ProductType: String{
    case Serial = "SERIAL"
    case Credential = "CREDINTIAL"
    case Predefined = "PRICED_VOUCHER"
    case Service = "SERVICE"
}

enum CHANNEL_CODES: String{
    case POS = "POS"
    case PORTAL = "PORTAL"
    case INTEGRATION = "INTEGRATION"
    case WALLET = "WALLET"
}


enum DATE: String {
   case CURRENT_MONTH = "CURRENT_MONTH"
   case LAST_MONTH = "LAST_MONTH"
   case LAST_SEVEN_DAYS = "LAST_SEVEN_DAYS"
   case YESTERDAY = "YESTERDAY"
   case TODAY = "TODAY"
}
