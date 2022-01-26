//
//  btrrStrings.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import Foundation
enum btrrStrings: String{
    case btrr = "Bank Transfer Recharging Requests";
    case btrr_status = "Status ";
    case btrr_status_all = "All";
    case btrr_status_pending = "Pending";
    case btrr_status_rejected = "Rejected";
    case btrr_status_accepted = "Accepted";
    case btrr_rejection_reason = "Rejection reason ";
    case btrr_no_data = "No Data Available";
    case btrr_no_more_data = "No More Data Available";
    case btrr_instruction = "Please follow the instructions";
    case btrr_select_bank = "Select bank account";
    case btrr_sender_details = "Sender Details";
    case btrr_transfer_details = "Transfer Details";
    case btrr_bank_transfer = "Bank Transfer";
    case btrr_countries = "Countries";
    case btrr_account_number = "Acc. No.";
    case btrr_account_name = "Acc. Name";
    case btrr_bank_address = "Bank address";
    case btrr_iban = "IBAN";
    case btrr_add_account = "Add New Account";
    case btrr_saved_accounts = "Saved accounts";
    case btrr_confirm_delete = "Are you sure you want to delete this account data?";
    case btrr_sender_country = "Sender’s bank country";
    case btrr_sender_bank_name = "Sender’s bank name*";
    case btrr_other = "Other";
    case btrr_add_bank_name = "Add bank name";
    case btrr_select_sender_bank = "Select bank";
    case btrr_sender_bank_no = "Sender’s bank account no.*";
    case btrr_sender_name = "Sender’s name*";
    case btrr_save_sender_bank = "Save account data";
    case btrr_warning = "Bank account and Bitaqaty Business account should have the same owner name";
    case btrr_transfer_from = "Transfer from\nSender’s country";
    case btrr_transfer_to = "Transfer to\nCountry";
    case btrr_transfer_amount = "Transfer amount*";
    case btrr_recharge_amount = "Recharge Amount";
    case amount = "Amount"
    case sar_full = "SAR"
    case btrr_transfer_date = "Transfer date*";
    case btrr_reference_no = "Reference No.*";
    case btrr_reference_no_hint = "ref.no.";
    case btrr_success = "Request submitted successfully";
    case btrr_success_msg = "Requests are processed daily within one hour from 8am to 2am KSA time";
    case btrr_min_amount_per_request = "Minimum transfer amount is XSAR";
    case btrr_max_amount_per_request = "Maximum transfer amount is XSAR";
    case btrr_export_date = "Date/Time";
    case btrr_export_name = "Sender’s name";
    case btrr_export_bank = "Transfer to";
    case btrr_export_amount = "Transfer amount";
    case btrr_export_transfer_date = "Transfer date";
    case btrr_export_status = "Status";
    case btrr_export_reason = "Rejection reason";
    case btrr_file_name = "Bank_Transfer_Recharging_Requests.csv"
    case btrr_instruction_1 = "First, transfer the amount from your bank account to business Bitaqaty account “Gulf Direct Distribution Company” before registering your transfer data on the Business Bitaqaty website.";
    case btrr_instruction_2 = "After completing the transfer process, enter the transfer information, by following the required steps: Select the bank account which you transferred to, the sender’s details and the transfer details.";
    case btrr_instruction_3 = "The E Payment department reviews your request and compares its data with your bank transfer data. The balance will be added when the data are identical.";
    case btrr_instruction_4 = "Requests are processed within30 minutes 7days a week from 8:00 Am to 2:00 AM.";
    case btrr_instruction_5 = "For request status, please check your registered email in Bitaqaty Business.";
    case btrr_instruction_6 = "Minimum transfer amount is 500 SAR.";
    case btrr_instruction_7 = "Maximum transfer amount is 50,000 SAR.";
    case btrr_instruction_8 = "Maximum number of requests are 3 time within 24 hours.";
    case btrr_instruction_9 = "Bank account and Bitaqaty Business account should have the same owner name.";
    case btrr_instruction_10 = "Please keep the transfer receipt as it could be requested for verification.";
    case btrr_instruction_11 = "We might call for verification, please make sure your mobile is available.";
    
    var localizedValue: String{
        switch self {
        case .btrr:
            if (lang != "en") {
                return "سجل طلبات شحن التحويل البنكي"
            }
            return self.rawValue
        case .btrr_status:
            if (lang != "en") {
                return "الحالة"
            }
            return self.rawValue
        case .btrr_status_all:
            if (lang != "en") {
                return "الكل"
            }
            return self.rawValue
        case .btrr_status_pending:
            if (lang != "en") {
                return "قيد الإنتظار"
            }
            return self.rawValue
        case .btrr_status_rejected:
            if (lang != "en") {
                return "مرفوض"
            }
            return self.rawValue
        case .btrr_status_accepted:
            if (lang != "en") {
                return "مقبول"
            }
            return self.rawValue
        case .btrr_rejection_reason:
            if (lang != "en") {
                return "سبب الرفض"
            }
            return self.rawValue
        case .btrr_no_data:
            if (lang != "en") {
                return "لا توجد بيانات"
            }
            return self.rawValue
        case .btrr_no_more_data:
            if (lang != "en") {
                return "لا يوجد المزيد من البيانات"
            }
            return self.rawValue
        case .btrr_instruction:
            if (lang != "en") {
                return "برجاء إتباع الإرشادات"
            }
            return self.rawValue
        case .btrr_select_bank:
            if (lang != "en") {
                return "اختر الحساب البنكي"
            }
            return self.rawValue
        case .btrr_sender_details:
            if (lang != "en") {
                return "تفاصيل المرسل"
            }
            return self.rawValue
        case .btrr_transfer_details:
            if (lang != "en") {
                return "تفاصيل التحويل"
            }
            return self.rawValue
        case .btrr_bank_transfer:
            if (lang != "en") {
                return "تحويل بنكي"
            }
            return self.rawValue
        case .btrr_countries:
            if (lang != "en") {
                return "الدولة"
            }
            return self.rawValue
        case .btrr_account_number:
            if (lang != "en") {
                return "رقم حساب"
            }
            return self.rawValue
        case .btrr_account_name:
            if (lang != "en") {
                return "إسم الحساب"
            }
            return self.rawValue
        case .btrr_bank_address:
            if (lang != "en") {
                return "عنوان البنك"
            }
            return self.rawValue
        case .btrr_iban:
            if (lang != "en") {
                return "IBAN"
            }
            return self.rawValue
        case .btrr_add_account:
            if (lang != "en") {
                return "إضافة حساب جديد"
            }
            return self.rawValue
        case .btrr_saved_accounts:
            if (lang != "en") {
                return "الحسابات المحفوظة"
            }
            return self.rawValue
        case .btrr_confirm_delete:
            if (lang != "en") {
                return "هل أنت متأكد أنك تريد مسح بيانات هذا الحساب ؟"
            }
            return self.rawValue
        case .btrr_sender_country:
            if (lang != "en") {
                return "دولة البنك (المحول منه)"
            }
            return self.rawValue
        case .btrr_sender_bank_name:
            if (lang != "en") {
                return "اسم البنك المحول منه*"
            }
            return self.rawValue
        case .btrr_other:
            if (lang != "en") {
                return "أخرى"
            }
            return self.rawValue
        case .btrr_add_bank_name:
            if (lang != "en") {
                return "أضف اسم البنك"
            }
            return self.rawValue
        case .btrr_select_sender_bank:
            if (lang != "en") {
                return "اختر اسم البنك"
            }
            return self.rawValue
        case .btrr_sender_bank_no:
            if (lang != "en") {
                return "رقم الحساب المحول منه*"
            }
            return self.rawValue
        case .btrr_sender_name:
            if (lang != "en") {
                return "اسم صاحب التحويل*"
            }
            return self.rawValue
        case .btrr_save_sender_bank:
            if (lang != "en") {
                return "حفظ بيانات الحساب"
            }
            return self.rawValue
        case .btrr_warning:
            if (lang != "en") {
                return "لن يتم قبول أي حوالة بنكية من حساب بنكي يختلف عن إسم صاحب حساب بطاقاتي أعمال"
            }
            return self.rawValue
        case .btrr_transfer_from:
            if (lang != "en") {
                return "تحويل من\nبلد المرسل"
            }
            return self.rawValue
        case .btrr_transfer_to:
            if (lang != "en") {
                return "تحويل إلى\nالدولة"
            }
            return self.rawValue
        case .btrr_transfer_amount:
            if (lang != "en") {
                return "مبلغ التحويل*"
            }
            return self.rawValue
        case .btrr_recharge_amount:
            if (lang != "en") {
                return "مبلغ الشحن"
            }
            return self.rawValue
        case .amount:
            if (lang != "en") {
                return "المبلغ"
            }
            return self.rawValue
        case .sar_full:
            if (lang != "en") {
                return "ريال سعودي"
            }
            return self.rawValue
        case .btrr_transfer_date:
            if (lang != "en") {
                return "تاريخ التحويل*"
            }
            return self.rawValue
        case .btrr_reference_no:
            if (lang != "en") {
                return "الرقم المرجعي*"
            }
            return self.rawValue
        case .btrr_reference_no_hint:
            if (lang != "en") {
                return "الرقم المرجعي"
            }
            return self.rawValue
        case .btrr_success:
            if (lang != "en") {
                return "تم تسجيل الطلب"
            }
            return self.rawValue
        case .btrr_success_msg:
            if (lang != "en") {
                return "إضافة الرصيد يتم خلال ساعة عمل واحدة يومياً من الثامنة صباحاً حتى الساعة الثانية بعد منتصف الليل بتوقيت السعودية"
            }
            return self.rawValue
        case .btrr_min_amount_per_request:
            if (lang != "en") {
                return "الحد الأدني لمبلغ التحويل XSAR"
            }
            return self.rawValue
        case .btrr_max_amount_per_request:
            if (lang != "en") {
                return "الحد الأقصى لمبلغ التحويل XSAR"
            }
            return self.rawValue
            
        case .btrr_export_date:
            if (lang != "en") {
                return "التاريخ/الوقت"
            }
            return self.rawValue
        case .btrr_export_name:
            if (lang != "en") {
                return "اسم المرسل"
            }
            return self.rawValue
        case .btrr_export_bank:
            if (lang != "en") {
                return "تحويل إلى"
            }
            return self.rawValue
        case .btrr_export_amount:
            if (lang != "en") {
                return "مبلغ التحويل"
            }
            return self.rawValue
        case .btrr_export_transfer_date:
            if (lang != "en") {
                return "تاريخ التحويل"
            }
            return self.rawValue
        case .btrr_export_status:
            if (lang != "en") {
                return "الحالة"
            }
            return self.rawValue
        case .btrr_export_reason:
            if (lang != "en") {
                return "سبب الرفض"
            }
            return self.rawValue
        case .btrr_file_name:
            if (lang != "en"){
                return "سجل_طلبات شحن_التحويل_البنكي.csv"
            }
            return self.rawValue
            
        case .btrr_instruction_1 :
            if (lang != "en"){
                return "قم بداية بتحويل المبلغ من حسابك البنكي الى حساب بطاقاتي أعمال ”شركة الخليج للتوزيع المباشر” قبل تسجيل  بيانات حوالتك على موقع بطاقاتي أعمال"
            }
            return self.rawValue
        case .btrr_instruction_2 :
            if (lang != "en"){
                return "بعد إتمام عملية التحويل, قم بإدخال بيانات الحوالة و ذلك بإتباع الخطوات المطلوبة : إختر الحساب البنكي الذي قمت بالتحويل له, تفاصيل المرسل و تفاصيل التحويل"
            }
            return self.rawValue
        case .btrr_instruction_3 :
            if (lang != "en"){
                return "يقوم قسم الدفع الالكتروني بمراجعة طلبك و مقارنة بياناته ببيانات حوالتك البنكية , سيتم اضافة الرصيد عندما تكون البيانات متطابقة"
            }
            return self.rawValue
        case .btrr_instruction_4 :
            if (lang != "en"){
                return "إضافة الرصيد يتم خالل 30 دقيقة على مدار االسبوع من الساعة 8 صباحا وحتى الساعة 2 صباحا."
            }
            return self.rawValue
        case .btrr_instruction_5 :
            if (lang != "en"){
                return " لمعرفة حالة الطلب، يرجى تفقد البريد اإللكتروني المسجل بحسابكم"
            }
            return self.rawValue
        case .btrr_instruction_6 :
            if (lang != "en"){
                return "الحد األدني للشحن 500 ريال سعودي"
            }
            return self.rawValue
        case .btrr_instruction_7 :
            if (lang != "en"){
                return "الحد األقصى للشحن 50,000 ريال سعودي"
            }
            return self.rawValue
        case .btrr_instruction_8 :
            if (lang != "en"){
                return "عدد طلبات الشحن المتاحه هو ثالثة مرات خلال 24ساعة"
            }
            return self.rawValue
        case .btrr_instruction_9 :
            if (lang != "en"){
                return "لن يتم قبول أي حوالة بنكية من حساب بنكي يختلف عن إسم صاحب حساب بطاقاتي أعمال"
            }
            return self.rawValue
        case .btrr_instruction_10 :
            if (lang != "en"){
                return "من الممكن أن يتم طلب صورة ايصال التحويل البنكي لذا يرجى االحتفاظ بها"
            }
            return self.rawValue
        case .btrr_instruction_11 :
            if (lang != "en"){
                return "قد يتم اإلتصال بكم فيرجى التأكد من أن يكون الهاتف متاحا"
            }
            return self.rawValue
        }
    }
}
