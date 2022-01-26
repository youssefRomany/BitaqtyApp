//
//  msgs.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
enum msgs: String{
    
    case yes = "Yes";
    case no = "No";
    case ok = "Ok";
    case continueTxt = "Contiune";
    case cancel = "Cancel";
    case exit = "Exit";
    case logout = "Logout";
    case selectLang = "Please select language"
    case appWillClose = "Application will be closed to apply your changes - please reopen it."
    case warning = "Warning"
    case loginFailed = "Error occurred while trying to login try again later";
    case loginCanceled = "User cancelled login";
    case serverError = "Server error";
    case errServer = "Something went wrong"
    case noInternet = "No Internet connection. Make sure that Wi-Fi or cellular mobile data is turned on, then try again."
    case retry = "Refresh ";
    case reload = "Reload";
    case doneTxt = "Done";
    case refresh = "Refresh";
    case searchMismatch = "No result for the search";
    case sign_dots = "**********";
    case english = "English"
    case arabic = "العربية"
    case export = "Export";
    case filter = "Filter";
    case from = "From";
    case to = "To";
    case next = "Next";
    case back = "Back";
    case confirm = "Confirm";
    case show_more = "Show more";
    case deleting = "Deleting..."
    case welcome = "Welcome to Bitaqaty Business"
    
    var localizedValue: String{
        switch self {
        case .yes:
            if (lang != "en") {
                return "نعم"
            }
            return self.rawValue
        case .no:
            if (lang != "en") {
                return "لا"
            }
            return self.rawValue
        case .ok:
            if (lang != "en") {
                return "حسنا"
            }
            return self.rawValue
        case .continueTxt:
            if (lang != "en") {
                return "استمر"
            }
            return self.rawValue
        case .cancel:
            if (lang != "en") {
                return "إلغاء"
            }
            return self.rawValue
        case .exit:
            if (lang != "en") {
                return "خروج"
            }
            return self.rawValue
        case .logout:
            if (lang != "en") {
                return "تسجيل خروج"
            }
            return self.rawValue
        case .selectLang:
            if (lang != "en") {
                return "برجاء اختيار اللغة"
            }
            return self.rawValue
        case .appWillClose:
            if (lang != "en") {
                return "سوف يتم إغلاق التطبيق لتنفيذ التعديلات ، ثم أعد فتح التطبيق مرة أخرى"
            }
            return self.rawValue
        case .warning:
            if (lang != "en") {
                return "تحذير"
            }
            return self.rawValue
        case .loginFailed:
            if (lang != "en") {
                return "حدث خطأ أثناء محاولة تسجيل الدخول حاول مرة أخرى في وقت لاحق"
            }
            return self.rawValue
        case .loginCanceled:
            if (lang != "en") {
                return "تم إلغاء تسجيل الدخول"
            }
            return self.rawValue
        case .serverError:
            if (lang != "en") {
                return "خطأ في الخادم";
            }
            return self.rawValue
        case .errServer:
            if (lang != "en") {
                return "حدث خطأ ما"
            }
            return self.rawValue
        case .noInternet:
            if (lang != "en") {
                return "لا يوجد اتصال بالإنترنت";
            }
            return self.rawValue
        case .retry:
            if (lang != "en") {
                return "تحديث "
            }
            return self.rawValue;
        case .reload:
            if (lang != "en") {
                return "أعد التحميل"
            }
            return self.rawValue;
        case .doneTxt:
            if (lang != "en") {
                return "تم";
            }
            return self.rawValue;
        case .refresh:
            if (lang != "en"){
                return "تحديث"
            }
            return self.rawValue;
        case .searchMismatch:
            if (lang != "en"){
                return "لا يوجد نتيجة للبحث";
            }
            return self.rawValue;
        case .english:
            return self.rawValue;
        case .arabic:
            return self.rawValue;
        case .sign_dots:
            return self.rawValue;
        case .export:
            if (lang != "en"){
                return "تصدير";
            }
            return self.rawValue;
        case .filter:
            if (lang != "en"){
                return "تصفية";
            }
            return self.rawValue;
        case .from:
            if (lang != "en"){
                return "من";
            }
            return self.rawValue;
        case .to:
            if (lang != "en"){
                return "إلى";
            }
            return self.rawValue;
        case .next:
            if (lang != "en"){
                return "التالي";
            }
            return self.rawValue;
        case .back:
            if (lang != "en"){
                return "عودة";
            }
            return self.rawValue;
        case .confirm:
            if (lang != "en"){
                return "تأكيد";
            }
            return self.rawValue;
        case .show_more:
            if (lang != "en"){
                return "عرض المزيد";
            }
            return self.rawValue;
        case .deleting:
            if (lang != "en"){
                return "جاري الحذف ...";
            }
            return self.rawValue;
        case .welcome:
            if (lang != "en"){
                return "مرحبا في بطاقاتي بيزنس";
            }
            return self.rawValue;
        }
    }
}
