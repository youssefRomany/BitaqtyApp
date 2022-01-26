//
//  errorMsgs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/12/21.
//

import Foundation
enum errorMsgs: String {
    case server = "Sorry, we were unable to process your request. Please try again shortly";
    case internet = "No Internet connection. \nMake sure that Wi-Fi or cellular mobile data is turned on, then try again.";
    case retry = "Retry";
    case no_data = "No Data Available";
    case reLogin_error = "Error login";
    
    case field_required = "This field is required";
    case invalid_email = "Email should be like example@example.com";
    case invalid_password = "Invalid password";
    case passwords_mismatch = "Passwords don’t match";
    case incorrect_username_password = "Incorrect username/password";
    case new_pass_match_old_pass = "New password shouldn’t be as current password";
    case session_ended = "Session is expired, please login";
    case sms_exceeded = "You have reached maximum sms attempts, please contact administrator";
    case sms_resend_exceeded = "You have exceeded number of allowed sms try again later";
    case invalid_verification_code = "Incorrect verification code";
    case verification_code_expired = "Sms Verification code expired\n\nPlease,request a new code";
    case try_again_later = "You have exceeded number of allowed sms try again after\n";
    case wrong_current_pass = "Incorrect password";
    case unauthorized = "login session has ended"
    case account_no_saved_before = "Account no. already saved before";
    case bank_account_not_found = "Bank account not found";
    case min_amount_per_request = "Min. allowed amount per request is : XSAR";
    case max_amount_per_request = "Max. allowed amount per request is : XSAR";
    case max_request_per_day = "Max. allowed bank requests per day : D/R";
    case max_amount_per_day = "Max. allowed amount per day : XSAR";
    case err_out_of_stock = "This product item is out of stock";
    case err_insufficient_stock = "Insufficient item in stock";
    case err_insufficient_balance = "Insufficient balance";
    case err_price_changed = "Product Price changed, Please go back and try again";
    case err_service_not_available = "Service not available now at the current moment, please try again later";
    case select_category = "Please, Select a Category first";
    case select_merchant = "Please, Select a merchant first";
    case select_from_first = "Select from date first";
    case invalid_custom_date = "Invalid custom date";
    case invalid_ticket_details = "Maximum characters is : 1500";
    
    
    
    var localizedValue: String{
        switch self {
        case .server:
            if (lang != "en") {
                return "عذرا، يرجى المحاولة مرة أخرى"
            }
            return self.rawValue
        case .internet:
            if (lang != "en") {
                return "لا يوجد إتصال بالإنترنت.\n من فضلك تأكد من إتصال هاتفك بالإنترنت ثم أعد المحاولة."
            }
            return self.rawValue
        case .retry:
            if (lang != "en") {
                return "أعد المحاولة"
            }
            return self.rawValue
        case .no_data:
            if (lang != "en") {
                return "لا توجد بيانات"
            }
            return self.rawValue
        case .reLogin_error:
            if (lang != "en") {
                return "خطأ في تسجيل الدخول"
            }
            return self.rawValue
            
        case .field_required:
            if (lang != "en") {
                return "هذا الحقل مطلوب"
            }
            return self.rawValue
        case .invalid_email:
            if (lang != "en") {
                return "البريد الإلكتروني يجب أن يكون example@example.com"
            }
            return self.rawValue
        case .invalid_password:
            if (lang != "en") {
                return "كلمة سر غير صالحه"
            }
            return self.rawValue
        case .passwords_mismatch:
            if (lang != "en") {
                return "كلمتي السر لا يتطابقان"
            }
            return self.rawValue
        case .incorrect_username_password:
            if (lang != "en") {
                return "اسم المستخدم/كلمة السر غير صحيحة"
            }
            return self.rawValue
        case .new_pass_match_old_pass:
            if (lang != "en") {
                return "كلمة السر الجديدة ﻻ يجب أن تكون ككلمة السر الحالية"
            }
            return self.rawValue
        case .session_ended:
            if (lang != "en") {
                return "إنتهت جلسة تسجيل الدخول, برجاء تسجيل الدخول"
            }
            return self.rawValue
        case .invalid_verification_code:
            if (lang != "en") {
                return "كود التحقيق غير صحيح"
            }
            return self.rawValue
        case .sms_exceeded:
            if (lang != "en") {
                return "لقد وصلت للحد الأقصى للمحاولات , برجاء التواصل مع خدمة العملاء"
            }
            return self.rawValue
        case .sms_resend_exceeded:
            if (lang != "en") {
                return "لقد تجاوزت عدد الرسائل القصيرة المسموح بها حاول مرة أخرى لاحقا"
            }
            return self.rawValue
        case .verification_code_expired:
            if (lang != "en") {
                return "انتهت صلاحية كود التحقق \n\n برجاء طلب كود تحقق جديد"
            }
            return self.rawValue
        case .try_again_later:
            if (lang != "en") {
                return "لقد تجاوزت عدد الرسائل القصيرة المسموح بها حاول مرة أخرى بعد\n"
            }
            return self.rawValue
        case .wrong_current_pass:
            if (lang != "en") {
                return "كلمة السر غير صحيحة"
            }
            return self.rawValue
        case .unauthorized:
            if (lang != "en") {
                return "انتهت جلسة تسجيل الدخول"
            }
            return self.rawValue
        case .account_no_saved_before:
            if (lang != "en") {
                return "رقم الحساب تم تسجيله بالفعل"
            }
            return self.rawValue
        case .bank_account_not_found:
            if (lang != "en") {
                return "هذا الحساب غير موجود"
            }
            return self.rawValue
        case .min_amount_per_request:
            if (lang != "en") {
                return "الحد اﻷدنى المسموح للطلب الواحد : XSAR"
            }
            return self.rawValue
        case .max_amount_per_request:
            if (lang != "en") {
                return "الحد اﻷقصى المسموح للطلب الواحد : XSAR"
            }
            return self.rawValue
        case .max_request_per_day:
            if (lang != "en") {
                return "الحد اﻷقصى المسموح لطلبات التحويل في اليوم: D/R"
            }
            return self.rawValue
        case .max_amount_per_day:
            if (lang != "en") {
                return "الحد اﻷقصى المسموح لليوم الواحد: XSAR"
            }
            return self.rawValue
            
        case .err_out_of_stock:
            if (lang != "en") {
                return "هذا المنتج غير متوفر"
            }
            return self.rawValue
        case .err_insufficient_stock:
            if (lang != "en") {
                return "المخزون غير كافي"
            }
            return self.rawValue
        case .err_insufficient_balance:
            if (lang != "en") {
                return "الرصيد غير كافي"
            }
            return self.rawValue
        case .err_price_changed:
            if (lang != "en") {
                return "تم تغيير سعر المنتج , برجاء العودة و المحاولة مرة أخرى"
            }
            return self.rawValue
        case .err_service_not_available:
            if (lang != "en") {
                return "هذة الخدمة غير متاحة في الوقت الحالي , برجاء المحاولة لاحقا"
            }
            return self.rawValue
            
        case .select_category:
            if (lang != "en") {
                return "برجاء, اختيار تصنيف أولا"
            }
            return self.rawValue
        case .select_merchant:
            if (lang != "en") {
                return "برجاء, اختيار خدمة أولا"
            }
            return self.rawValue
        case .select_from_first:
            if (lang != "en") {
                return "إختر من أولاً"
            }
            return self.rawValue
        case .invalid_custom_date:
            if (lang != "en") {
                return "تاريخ محدد غير صالح"
            }
            return self.rawValue
        case .invalid_ticket_details:
            if (lang != "en") {
                return "الحد الأقصى المسموح به: 1500 حرف"
            }
            return self.rawValue
        }
    }
}
