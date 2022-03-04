//
//  APIBuilder.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/12/21.
//

import Foundation
enum API {
    static let BASE_URL = "https://api-bitaqatybusiness.ocstaging.net/bitaqaty-business/" // Staging
    //static let BASE_URL = "https://api.bitaqatybusiness.com/bitaqaty-business/" // Production
}

enum AUTH_API{
    static let login = "auth/login"
    static let authenticated_login = "auth/authenticated-login"
    static let login_change_password = "auth/login-change-password"
    static let reset_change_password = "auth/forget-password-change"
    static let change_password = "profile/change-password"
    static let validate_sms_code = "auth/validate-sms-verification-code"
    static let forget_password = "auth/forget-password"
    static let logout = "auth/logout"
    static let remaining_trials = "auth/sms-verification-remaining-trials"
    static let accept_agreement = "auth/accept-agreement"
    static let profile = "auth/get-reseller"
    static let whiteLabel = "auth/white-label-system-setting"
}

enum RESELLER_HOME_APIs{
    static let GET_DAILY_SALES = "reseller-home/list-daily-sales"
    static let GET_DAILY_RECHARGE = "reseller-home/list-daily-recharge"
    static let GET_SUB_ACCOUNTS_SALES = "reseller-home/list-sub-accounts-by-sales"
    static let GET_SELLER_HOME_BANK_REQUESTS = "reseller-home/bank-transfer-requests"
}

enum SUB_SELLER_HOME_APIs{
    static let SUB_ACCOUNT_HOME = "sub-acc-home/top-merchants"
    static let SUB_ACCOUNT_HOME_CHILD = "sub-acc-home/list-child-merchants"
}

enum MANAGE_API{
    static let MANAGE_SUB_ACCOUNT_LIST = "manage-sub-accounts/list-sub-accounts"
    static let UPDATE_SUB_ACCOUNT = "manage-sub-accounts/update-sub-account"
    static let RESET_LIMIT = "manage-sub-accounts/reset-sub-account_limit/"
    static let EXPORT_SUB_ACCOUNT_LIST = "manage-sub-accounts/export-sub-accounts"
}

enum RECHARGE_API{
    static let RESELLER_RECHARGE_METHODS = "charging-methods/get-charging-methods"
    static let GET_AMOUNT_AFTER = "charging-methods/get-amount"
    static let GET_CHECKOUT_ID = "charging-methods/get-checkout-id"
    static let GET_PAYMENT_STATUS = "charging-methods/get-payment-status"
    static let GET_PAYPAL_DENOMANATIONS = "charging-methods/get-paypal-denomenations"
    static let GET_PAYPAL_AMOUNT = "charging-methods/get-paypal-amount"

}
enum RECHARGING_LOG_APIs{
    static let GET_RECHARGE_LOG_METHODS = "charging-log/get-charging-log-methods"
    static let GET_RECHARGE_LOG_LIST = "charging-log/get-charging-log"
    static let EXPORT_RECHARGE_LOG_LIST = "charging-log/export-charging-log"

}
enum SYSTEM_API{
    static let SYSTEM_SETTINGS = "system-settings/system-settings"
}

enum PRODUCT_APIs{
    static let GET_PRODUCT_LIST = "products/list-products"
    static let GET_CATEGORY_LIST = "lookups/list-categories"
    static let GET_MERCHANT_LIST = "lookups/list-merchants/"
    static let EXPORT_PRODUCT_LIST = "products/export-products-list"
}
enum TRANSACTION_LOG_APIs{
    static let GET_USERNAMES_LIST = "transaction-log/list-sub-accounts"
    static let GET_TRANSACTIONS_LIST = "transaction-log/list-transaction-log"
    static let EXPORT_TRANSACTIONS_LIST = "transaction-log/export-transaction-log"
}

enum BANK_TRANSFER_API{
    static let SEARCH_BANK_TRANSFER_REQUEST = "bank-transfer/search-bank-transfer-requests"
    static let EXPORT_BANK_TRANSFER_REQUEST = "bank-transfer/export-bank-transfer-requests"
    static let ONE_CARD_COUNTRIES = "bank-transfer/list-onecard-accounts-countries"
    static let ONE_CARD_ACCOUNTS = "bank-transfer/list-onecard-accounts-by-country"
    static let SAVED_ACCOUNTS = "bank-transfer/list-saved-accounts"
    static let SENDER_COUNTRIES = "bank-transfer/list-sender-countries"
    static let SENDER_ACCOUNTS_BY_COUNTRY = "bank-transfer/list-sender-banks-by-country/"
    static let DELETE_SENDER_ACCOUNT = "bank-transfer/delete-saved-account"
    static let CALCULATE_RECHARGE_AMOUNT = "bank-transfer/calculate-recharge-amount"
    static let SAVE_SENDER_ACCOUNT = "bank-transfer/save-or-update-bank-account"
    static let PLACE_REQUEST = "bank-transfer/place-bank-transfer-request"
}

enum PURCHASE_API{
    static let GET_STORES = "categories/list-categories"
    static let GET_MERCHANTS = "merchants/list-merchants/"
    static let GET_PRODUCTS = "products/list-products"
    static let PURCHASE = "purchase/purchase-product"
}

enum REPORT_APIs{
    static let GET_USER_NAME = "sales-report/list-sub-accounts"
    static let GET_STORES = "lookups/list-categories"
    static let GET_MERCHANTS = "lookups/list-merchants/"
    static let GET_PRODUCTS = "lookups/list-products"
    static let GENERATE_REPORT = "sales-report/generate-sales-report"
    static let EXPORT_REPORT = "sales-report/export-sales-report"
}

enum SUPPORT_APIs{
    static let GET_TICKET_TYPE = "support/get-ticket-types"
    static let ADD_TICKET = "support/add-ticket"
}

enum API_ERRORS: String {
    case USER_DID_NOT_HAS_PERMISSION = "56"
    case PasswordNotChanged = "15";
    case AgreementNotAccepted = "17";
    case InvalidAccessType = "19";
    case NewPassEqualsOldPass = "20";
    case NewPassNotEqualsConfPass = "21";
    case NewPassNotEqualsRegex = "22";
    case MissingNewPass = "28";
    case MissingConfPass = "29";
    case InvalidUserNameOrPassword = "31";
    case InvalidLoginProcessToken = "33";
    case SmsAuthSent = "37";
    case InvalidSmsVerificationCode = "39";
    case ExceededMaxAllowedSms = "41";
    case ExceededMaxAllowedResendSmsLimit = "42";
    case IncorrectCurrentPassword = "45";
    case IpLocationSMSAuthSent = "101";
    case SmsVerificationExpired = "108";
}

enum BankTransferError: String {
    case BANK_ACCOUNT_NOT_FOUND = "86";
    case BANK_ACCOUNT_ALREADY_EXIST = "87";
    case CHARGING_BANK_TRANSFER_AMOUNT_LESS_THAN_MIN_AMOUNT = "89";
    case CHARGING_BANK_TRANSFER_AMOUNT_GREATER_THAN_MAX_AMOUNT = "90";
    case INVALID_AMOUNT = "92";
    case EXCEEDED_MAXIMUM_NUMBER_OF_REQUESTS = "93";
    case CHARGING_BANK_TRANSFER_AMOUNT_PER_DAY = "94";
}

enum PurchaseErrors: String {
    case PRODUCT_PRICE_CHANGED = "51";
    case UNABLE_TO_PURCHASE = "52";
    case INVALID_PRODUCT_PRICE = "53";
    case NOT_SELLABLE_PRODUCT = "54";
    case INSUFFICIENT_RESELLER_BALANCE = "62";
    case INSUFFICIENT_ITEMS_IN_STOCK = "63";
    case BULK_PURCHASE_DISABLED = "64";
    case INVALID_PRODUCT_TYPE_FOR_BULK_PURCHASE = "65";
    case INVALID_NUMBER_OF_ITEMS_IN_BULK_PURCHASE = "66";
    case BULK_NOT_ALLOWED_FOR_SERVICE_PRODUCT = "67";
    case NOT_PRODUCT_ITEMS_FOUND = "80";
    case PRODUCT_OUT_OF_STOCK = "128";
}


enum ServiceError: Error {
    case noInternetConnection
    case custom(ErrorMessage)
    case other
    case unauthorized
    
    var errorDescription: String {
        switch self {
        case .noInternetConnection:
            return msgs.noInternet.localizedValue
        case .other:
            return errorMsgs.server.localizedValue
        case .custom(let error):
            return error.errorMessage
        case .unauthorized:
            return errorMsgs.session_ended.localizedValue
        }
    }
    
    var code: String{
        switch self{
        case .custom(let error):
            return error.errorCode
        default:
            return "-1"
        }
    }
    
    init(_ errors: [ErrorMessage]) {
        if errors.isEmpty{
            self = .other
        }else{
            self = .custom(errors[0])
        }
    }
}
