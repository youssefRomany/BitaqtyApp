//
//  Strings.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/22/21.
//
import Foundation
enum strings: String{
    case CRText = "Copyright © 2020 Bitaqaty business. All rights reserved.";
    case Home = "Home"
    case TransactionLog = "Transactions Log"
    case ProductList = "Products Discount List"
    case moreProductList = "Products Discount List "

    case More = "More"
    case Recharge = "Recharge"
    case Hello = "Hello,"
    case YourBalance = "Balance:"
    case supportTitle = "Reseller Support Center"
    case store = "Store"
    case bankTransfer = "Bank Transfer"
    case mada = "MADA"
    case credit = "Credit Card"
    case amex = "AMEX"
    case paypal = "PayPal"
    case sar = "SAR"
    case rechargeLog = "Recharging Log"
    case rechargeRequests = "Recharging requests"
    case bankTransferLog = "Bank transfer"
    case app_name = "Bitaqaty";
    case change_password = "Change password";
    case language = "Language";
    case choose_language = "Choose Language"
    case current_lang = "(English)";
    case loading = "Loading…";
    case days = "day(s)";
    case hours = "hour(s)";
    case mins = "minute(s)";
    case secs = "second(s)";
    case periodic_limit = "Periodic Limit";
    case noPermission = "You don't have permissions to view this page";

    var localizedValue: String{
        switch self {
        case .CRText:
            if (lang != "en") {
                return "© 2020 Bitaqaty جميع الحقوق محفوظة لصالح"
            }
            return self.rawValue
        case .Home:
            if (lang != "en") {
                return "الرئيسية"
            }
            return self.rawValue
        case .TransactionLog:
            if (lang != "en") {
                return "سجل العمليات"
            }
            return self.rawValue
        case .ProductList:
            if (lang != "en") {
                return "قائمة خصومات \n المنتجات"
            }
            return self.rawValue
        case .moreProductList:
            if (lang != "en") {
                return " قائمة خصومات المنتجات"
            }
            return self.rawValue
        case .More:
            if (lang != "en") {
                return "المزيد"
            }
            return self.rawValue
        case .Recharge:
            if (lang != "en") {
                return "شحن"
            }
            return self.rawValue
        case .Hello:
            if (lang != "en") {
                return "مرحبا,"
            }
            return self.rawValue
        case .YourBalance:
            if (lang != "en") {
                return "رصيدك:"
            }
            return self.rawValue
            
        case .supportTitle:
            if (lang != "en") {
                return "خدمة الموزعين"
            }
            return self.rawValue
        case .store:
            if (lang != "en") {
                return "المتجر"
            }
            return self.rawValue
        case .bankTransfer:
            if (lang != "en") {
                return "تحويل بنكي"
            }
            return self.rawValue
        case .mada:
            if (lang != "en") {
                return "مدي"
            }
            return self.rawValue
        case .credit:
            if (lang != "en") {
                return "بطاقة الائتمان"
            }
            return self.rawValue
        case .amex:
            if (lang != "en") {
                return "امكس"
            }
            return self.rawValue
        case .paypal:
            if (lang != "en") {
                return "باي بال"
            }
            return self.rawValue
        case .sar:
            if (lang != "en") {
                return "ر.س"
            }
            return self.rawValue
        case .rechargeRequests:
            if (lang != "en") {
                return "طلبات الشحن"
            }
            return self.rawValue
        case .rechargeLog:
            if (lang != "en") {
                return "سجل الشحن"
            }
            return self.rawValue
        case .bankTransferLog:
            if (lang != "en") {
                return "تحويل بنكي"
            }
            return self.rawValue
        case .app_name:
            if (lang == "ar"){
                return "Bitaqaty";
            }
            return self.rawValue;
        case .change_password:
            if (lang == "ar"){
                return "تغيير كلمة السر";
            }
            return self.rawValue;
        case .language:
            if (lang == "ar"){
                return "اللغة";
            }
            return self.rawValue;
        case .choose_language:
            if (lang == "ar"){
                return "إختيار اللغة";
            }
            return self.rawValue;
        case .current_lang:
            if (lang == "ar"){
                return "(العربية)";
            }
            return self.rawValue;
        case .loading:
            if (lang == "ar"){
                return "جار التحميل…";
            }
            return self.rawValue;
        case .days:
            if (lang == "ar"){
                return "أيام";
            }
            return self.rawValue;
        case .hours:
            if (lang == "ar"){
                return "ساعات";
            }
            return self.rawValue;
        case .mins:
            if (lang == "ar"){
                return "دقائق";
            }
            return self.rawValue;
        case .secs:
            if (lang == "ar"){
                return "ثواني";
            }
            return self.rawValue;
        case .periodic_limit:
            if (lang == "ar"){
                return "محدد بمدة";
            }
            return self.rawValue;
        case .noPermission:
            if (lang == "ar"){
                return "ليس لديك تصريح لمشاهدة هذه الصفحة";
            }
            return self.rawValue;
        }
    }
}
