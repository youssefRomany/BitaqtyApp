//
//  TransactionStrings.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/21/21.
//

import Foundation
enum TransactionStrings: String{
    case TLogUserName = "Username"
    case TLogSerialNo = "Serial No."
    case TLogPin = "PIN"
    case TLogPassword = "Password"
    case TLogChannel = "Channel"
    case TLogPrinted = "Printed ?"
    case TLogFrom = "From"
    case TLogTo = "To"
    case TLogSupport = "Support Ticket"
    case TLogPrint = "Print"
    case TLogCanceled = "Canceled"
    case TLogCostAfter = "Total Cost after VAT"
    case TLogTransID = "Trans. ID"
    case TLogCostPrice = "Cost Price"
    case TLogVATAmount = "VAT Amount"
    case TLogBalance = "Balance"
    case TLogPricesCurrency = "All prices in currency: [X]"
    case exportedTransLogSheetName = "Transactions_log"
    case exportedTransLogFile = "Transactions_log.csv"
    case channer_arr_all = "All"
    case channer_arr_portal = "Portal"
    case channer_arr_pos = "POS"
    case channer_arr_integration = "Integration"
    case channer_arr_wallet = "Wallet"
    case yes = "Yes"
    case no = "No"
    case case_sensitive = "[WORD] is case sensitive"
    case productName = "Product Name"
    case TLogPin2 = "Password "
    case pin = "PIN "
    case recommended_retail_price = "Recommended Retail Price"
    case recommended_retail_price_after_vat = "Recommended Retail Price after VAT"
    case expected_profit = "Expected Profit"

    var localizedValue: String{
        switch self {
        case .TLogUserName:
            if (lang == "ar"){
                return "اسم المستخدم ";
            }
            return self.rawValue;
        case .TLogSerialNo:
            if (lang == "ar"){
                return "الرقم التسلسلي";
            }
            return self.rawValue;
        case .TLogPin:
            if (lang == "ar"){
                return " كلمة المرور";
            }
            return self.rawValue;
        case .TLogPassword:
            if (lang == "ar"){
                return "كلمة السر";
            }
            return self.rawValue;
        case .TLogChannel:
            if (lang == "ar"){
                return "القناة";
            }
            return self.rawValue;
        case .TLogPrinted:
            if (lang == "ar"){
                return " طباعة ؟";
            }
            return self.rawValue;
        case .TLogFrom:
            if (lang == "ar"){
                return "من";
            }
            return self.rawValue;
        case .TLogTo:
            if (lang == "ar"){
                return "إلى";
            }
            return self.rawValue;
        case .TLogSupport:
            if (lang == "ar"){
                return "تذكرة دعم";
            }
            return self.rawValue;
        case .TLogPrint:
            if (lang == "ar"){
                return "طباعة";
            }
            return self.rawValue;
        case .TLogCanceled:
            if (lang == "ar"){
                return "ملفي";
            }
            return self.rawValue;
        case .TLogCostAfter:
            if (lang == "ar"){
                return "إجمالي التكلفة بعد الضريبة ";
            }
            return self.rawValue;
        case .TLogTransID:
            if (lang == "ar"){
                return " رقم العملية ";
            }
            return self.rawValue;
        case .TLogCostPrice:
            if (lang == "ar"){
                return "سعر التكلفة";
            }
            return self.rawValue;
        case .TLogVATAmount:
            if (lang == "ar"){
                return "مبلغ الضريبة ";
            }
            return self.rawValue;
        case .TLogBalance:
            if (lang == "ar"){
                return "الرصيد";
            }
            return self.rawValue;
        case .TLogPricesCurrency:
            if (lang == "ar"){
                return "كل الأسعار بعملة: [X]";
            }
            return self.rawValue;
        case .exportedTransLogSheetName:
            if (lang == "ar"){
                return "سجل_العمليات";
            }
            return self.rawValue;
        case .exportedTransLogFile:
            if (lang == "ar"){
                return "سجل_العمليات.csv";
            }
            return self.rawValue;
        case .channer_arr_all:
            if (lang == "ar"){
                return "الكل";
            }
            return self.rawValue;
        case .channer_arr_pos:
            if (lang == "ar"){
                return "نقطة البيع";
            }
            return self.rawValue;
        case .channer_arr_portal:
            if (lang == "ar"){
                return "الموقع الإلكتروني";
            }
            return self.rawValue;
        case .channer_arr_wallet:
            if (lang == "ar"){
                return "المحفظة";
            }
            return self.rawValue;
        case .channer_arr_integration:
            if (lang == "ar"){
                return "ربط خارجي";
            }
            return self.rawValue;
        case .yes:
            if (lang == "ar"){
                return "نعم";
            }
            return self.rawValue;
            
        case .no:
            if (lang == "ar"){
                return "لا";
            }
            return self.rawValue;
        case .case_sensitive:
            if (lang == "ar"){
                return "[WORD]";
            }
            return self.rawValue;
        case .productName:
            if (lang == "ar"){
                return "اسم المنتج";
            }
            return self.rawValue;
        case .TLogPin2:
            if (lang == "ar"){
                return "  كلمة المرور";
            }
            return self.rawValue;
        case .pin:
            if (lang != "en"){
                return " الرقم السري"
            }
            return self.rawValue;
        case .recommended_retail_price:
            if (lang != "en"){
                return "سعر البيع المقترح"
            }
            return self.rawValue;
        case .recommended_retail_price_after_vat:
            if (lang != "en"){
                return "سعر البيع المقترح بعد الضريبة"
            }
            return self.rawValue;
        case .expected_profit:
            if (lang != "en"){
                return "الربح المتوقع"
            }
            return self.rawValue;
        }
    }
}
