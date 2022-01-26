//
//  manageStrings.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/27/21.
//

import Foundation
enum manageStrings: String{
    case accountType = "Account type"
    case status = "Status"
    case purchasing_limit = "Purchasing limit"
    case manage = "Manage"
    case export = "Export"
    case limit = "Limited"
    case periodic = "Periodic"
    case notLimited = "Unlimited"
    case enabled = "Enabled"
    case disabled = "Disabled"
    case search_hint = "Search"
    case exportFileName = "SubSellers list"
    case export_success = "Data exported successfully"
    case export_error = "Something went wrong"
    case show_more = "Show more"
    case renewal_limit_to_default = "Renewal Limit to Default"
    
    case enable_account = "Enable Account"
    case fullName = "Full Name"
    case mobileNumber = "Mobile Number"
    case description = "Description"
    case accessType = "Access Type"
    case purchase = "Purchase"
    case canPurchase = "This account can purchase any product"
    case amountLimited = "Amount will be limited for the account"
    case amountPeriodic = "Balance will be added Periodically"
    case amountNotLimited = "Account\'s balance will be from the Master Account balance with no limit"
    case balance = "Balance"
    case purchaseLimit = "Purchase Limit"
    case amount = "Amount"
    case currentRemaining = "Current Remaining Limit"
    case viewPurchaseLimit = "View Purchase Limit"
    case viewProductDiscounts = "View Products Discounts"
    case viewProductDiscountsDetails = "In case of hiding all prices(product price, VAT amount, and after VAT) will be hidden in all Purchases Cycle, Products List, Reports, and Logs"
    case rechargingLog = "Recharging Log"
    case rechargingMethod = "Choose Recharging Method"
    case chooseLogType = "Choose Log type"
    case transLogOption1 = "Transactions log of his account only"
    case transLogOption2 = "Transactions log of all the sub-accounts"
    case chooseReportTitle = "Choose report type"
    case reportsOption1 = "Reports of his account only"
    case reportsOption2 = "Reports of all accounts"
    case resellerSupportAction = "Resellers Support Center"
    case resellerSupportActionDetail = "This account can communicate with our Reseller support through LiveChat, Whatsapp or opening ticket"
    case productDiscountsList = "Products Discounts List"
    case save = "Save"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case DEFAULT = "Default"
    
    case web = "Web"
    case application = "Application"
    case viewMasterAccount = "Allow to View Master Account Balance"
    case errorRechargePermission = "Select at least one permission"
    case updateSuccessful = "Changed successfully"
    
    case export_user_name = "Username"
    case export_full_name = "Full Name "
    case export_account_type = "Account Type"
    case export_status = "Status "
    case export_purchase_limit = "Purchase Limit "
    case exportefFileName = "Sub Accounts.csv"
    case error_opening_file = "Error opening file"
    case error_not_Saved = "File is not saved"
    case manage_account = "Manage Account"
    case error_export_data = "No data to be exported"
    case no_search_result = "No Search result"
    case err_enterBalance = "You need to enter purchase limit"
    case saving = "Saving..."
    case period = "Period"

    
    var localizedValue: String{
        switch self {
        case .status:
            if (lang == "ar"){
                return "الحالة"
            }
            return self.rawValue;
        case .purchasing_limit:
            if (lang == "ar"){
                return "الحد الأقصى للشراء"
            }
            return self.rawValue;
        case .manage:
            if (lang == "ar"){
                return "ادارة"
            }
            return self.rawValue;
        case .export:
            if (lang == "ar"){
                return "تصدير"
            }
            return self.rawValue;
        case .limit:
            if (lang == "ar"){
                return "محدد"
            }
            return self.rawValue;
        case .periodic:
            if (lang == "ar"){
                return "دوري"
            }
            return self.rawValue;
        case .notLimited:
            if (lang == "ar"){
                return "غير محدد"
            }
            return self.rawValue;
        case .enabled:
            if (lang == "ar"){
                return "مفعل"
            }
            return self.rawValue;
        case .disabled:
            if (lang == "ar"){
                return "غير مفعل"
            }
            return self.rawValue;
        case .search_hint:
            if (lang == "ar"){
                return "بحث"
            }
            return self.rawValue;
        case .export_error:
            if (lang == "ar"){
                return "حدث خطأ"
            }
            return self.rawValue;
        case .exportFileName:
            if (lang == "ar"){
                return "الحسابات الفرعية"
            }
            return self.rawValue;
        case .export_success:
            if (lang == "ar"){
                return " تم تصدير البيانات بنجاح"
            }
            return self.rawValue;
        case .show_more:
            if (lang == "ar"){
                return "عرض المزيد"
            }
            return self.rawValue;
        case .renewal_limit_to_default:
            if (lang == "ar"){
                return "إعادة تعيين حد الرصيد"
            }
            return self.rawValue;
        case .enable_account:
            if (lang == "ar"){
                return "تفعيل الحساب"
            }
            return self.rawValue;
        case .fullName:
            if (lang == "ar"){
                return "الاسم بالكامل"
            }
            return self.rawValue;
        case .mobileNumber:
            if (lang == "ar"){
                return "رقم الجوال"
            }
            return self.rawValue;
        case .description:
            if (lang == "ar"){
                return "الوصف"
            }
            return self.rawValue;
        case .accessType:
            if (lang == "ar"){
                return "نوع الدخول"
            }
            return self.rawValue;
        case .purchase:
            if (lang == "ar"){
                return "الشراء"
            }
            return self.rawValue;
        case .canPurchase:
            if (lang == "ar"){
                return "(يمكن لهذا الحساب شراء أي من المنتجات)"
            }
            return self.rawValue;
        case .accountType:
            if (lang == "ar"){
                return "نوع الحساب"
            }
            return self.rawValue;
        case .amountLimited:
            if (lang == "ar"){
                return "سيتم تخصيص حد أقصى للشراء للحساب"
            }
            return self.rawValue;
        case .amountPeriodic:
            if (lang == "ar"){
                return "سيتم وضع رصيد بشكل دوري في الحساب"
            }
            return self.rawValue;
        case .amountNotLimited:
            if (lang == "ar"){
                return "رصيد هذا الحساب سيكون من رصيد الحساب الرئيسي"
            }
            return self.rawValue;
        case .balance:
            if (lang == "ar"){
                return "الرصيد"
            }
            return self.rawValue;
        case .purchaseLimit:
            if (lang == "ar"){
                return "الحد الأقصى للشراء"
            }
            return self.rawValue;
        case .amount:
            if (lang == "ar"){
                return "المبلغ"
            }
            return self.rawValue;
        case .currentRemaining:
            if (lang == "ar"){
                return "حد الشراء المتبقى"
            }
            return self.rawValue;
        case .viewPurchaseLimit:
            if (lang == "ar"){
                return "إظهار الحد الأقصى للشراء"
            }
            return self.rawValue;
        case .rechargingMethod:
            if (lang == "ar"){
                return "أختر طريقة الشحن"
            }
            return self.rawValue;
        case .rechargingLog:
            if (lang == "ar"){
                return "سجل الشحن"
            }
            return self.rawValue;
        case .chooseLogType:
            if (lang == "ar"){
                return "أختر نوع السجل"
            }
            return self.rawValue;
        case .transLogOption1:
            if (lang == "ar"){
                return "سجل عمليات الحساب فقط"
            }
            return self.rawValue;
        case .transLogOption2:
            if (lang == "ar"){
                return "سجل عمليات لكل الحسابات"
            }
            return self.rawValue;
        case .chooseReportTitle:
            if (lang == "ar"){
                return "أختر نوع التقارير"
            }
            return self.rawValue;
        case .reportsOption1:
            if (lang == "ar"){
                return "تقارير الحساب فقط"
            }
            return self.rawValue;
        case .reportsOption2:
            if (lang == "ar"){
                return "تقارير كل الحسابات"
            }
            return self.rawValue;
        case .resellerSupportAction:
            if (lang == "ar"){
                return "خدمة الموزعين"
            }
            return self.rawValue;
        case .resellerSupportActionDetail:
            if (lang == "ar"){
                return "هذا الحساب يمكنه التواصل مع خدمة الموزعين بالمحادثة , واتس آب أو عمل تذكرة"
            }
            return self.rawValue;
        case .viewProductDiscounts:
            if (lang == "ar"){
                return "إظهار خصومات المنتجات"
            }
            return self.rawValue;
        case .viewProductDiscountsDetails:
            if (lang == "ar"){
                return "في حالة الإخفاء سيتم إخفاء كل الأسعار (سعر المنتج و الضريبة و بعد الضريبة) في عمليات الشراء و قوائم المنتجات و التقاربر و السجلات"
            }
            return self.rawValue;
        case .productDiscountsList:
            if (lang == "ar"){
                return "قائمة خصومات المنتجات"
            }
            return self.rawValue;
        case .save:
            if (lang == "ar"){
                return "حفظ"
            }
            return self.rawValue;
        case .daily:
            if (lang == "ar"){
                return "يومي"
            }
            return self.rawValue;
        case .weekly:
            if (lang == "ar"){
                return "أسبوعي"
            }
            return self.rawValue;
        case .monthly:
            if (lang == "ar"){
                return "شهري"
            }
            return self.rawValue;
        case .DEFAULT:
            if (lang == "ar"){
                return "أفتراضي"
            }
            return self.rawValue;
        case .web:
            if (lang == "ar"){
                return "الويب"
            }
            return self.rawValue;
        case .application:
            if (lang == "ar"){
                return "التطبيق"
            }
            return self.rawValue;
        case .viewMasterAccount:
            if (lang == "ar"){
                return "إتاحة إظهار رصيد الحساب الرئيسى"
            }
            return self.rawValue;
        case .errorRechargePermission:
            if (lang == "ar"){
                return "اختر تصريح واحد على الأقل"
            }
            return self.rawValue;
            
        case .updateSuccessful:
            if (lang == "ar"){
                return "تم التغيير بنجاح"
            }
            return self.rawValue;
        case .export_user_name:
            if (lang == "ar"){
                return "اسم المستخدم"
            }
            return self.rawValue;
        case .export_full_name:
            if (lang == "ar"){
                return "الاسم بالكامل"
            }
            return self.rawValue;
        case .export_account_type:
            if (lang == "ar"){
                return "نوع الحساب"
            }
            return self.rawValue;
        case .export_status:
            if (lang == "ar"){
                return "الحالة"
            }
            return self.rawValue;
        case .export_purchase_limit:
            if (lang == "ar"){
                return "  الحد الأقصى للشراء"
            }
            return self.rawValue;
        case .exportefFileName:
            if (lang == "ar"){
                return "/الحسابات الفرعية.csv"
            }
            return self.rawValue;
        case .error_opening_file:
            if (lang == "ar"){
                return "خطأ في فتح الملف"
            }
            return self.rawValue;
        case .error_not_Saved:
            if (lang == "ar"){
                return "لم يتم حفظ الملف"
            }
            return self.rawValue;
        case .manage_account:
            if (lang == "ar"){
                return "إدارة الحساب"
            }
            return self.rawValue;
        case .error_export_data:
            if (lang == "ar"){
                return "لا يوجد بيانات للتصدير"
            }
            return self.rawValue;
        case .no_search_result:
            if (lang == "ar"){
                return "لا يوجد نتائج للبحث"
            }
            return self.rawValue;
        case .err_enterBalance:
            if (lang == "ar"){
                return "يجب أدخال قيمة للرصيد"
            }
            return self.rawValue;
        case .saving:
            if (lang == "ar"){
                return "جاري الحفظ..."
            }
            return self.rawValue;
        case .period:
            if (lang == "ar"){
                return "دوري "
            }
            return self.rawValue;
        }
        
    }
    
}
