//
//  UserStrings.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
enum accountStrings: String{
    case sign_welcome = "Welcome\nto Bitaqaty Business";
    case send = "Send";
    case code = "Code";
    case sign_in = "Sign in";
    case sign_dots = "**********";
    case english = "English"
    case arabic = "العربية"
    
    case sign_instruction = "To login, please enter your email address and password and click on Sign in"
    case sign_username = "Email address/Username*"
    case sign_password = "Password*"
    case sign_forgot_password = "Forgot password ?"
    case sign_signing = "Signing in…"
    
    case pass_enter_new_password = "Enter new password"
    case pass_instruction = "Enter New Password and Confirm New Password and click Change"
    case pass_change = "Change"
    case pass_current_pass = "Current Password*"
    case pass_new_pass = "New Password*"
    case pass_conf_new_pass = "Confirm New Password*"
    case pass_validation_1 = "Should be written in English"
    case pass_validation_2 = "Contain at least 8 characters"
    case pass_validation_3 = "Contain at least one small letter"
    case pass_validation_4 = "Contain at least one capital letter"
    case pass_validation_5 = "Contain at least one number"
    case pass_applying_change = "Applying change…"
    case pass_change_success = "Password is changed successfully, you can now login with the new password"
    
    case reset_password = "Restore Password"
    case reset_instruction = "To restore your forgotten password, please enter your email address or username, and click [Send]. A message containing verification code will be sent to you, please use that code to change your password. Please note that this code is valid within one hour"
    case reset_email = "Email Address/UserName*"
    case reset_link_sent = "Link is resent"
    case reset_resend = "Resend link"
    case reset_success_msg = "An email has been sent to EMAIL_TXT, To reset your password, Please click on the verification link from Bitaqaty via email\n\nFor help: You can contact our Resellers support now\n\n\nIf you do not receive the message, you can click resend link"
    
    case verification_enter_code = "Enter Verification code"
    case verification_instruction = "Please enter the Sms Verification Code sent to your account’s mobile number and click Sign in"
    case verification_code = "Verification code"
    case verification_resend = "Resend again"
    case verification_resend_message = "In case you didn’t receive code press"
    case verification_trial = "Trials"
    case verification_wait = "Wait"
    case verification_seconds = "Seconds"
    case verification_verifying = "Verifying…"
    case verification_code_sent = "Verification code sent"
    
    case profile_account_no = "Account no."
    case profile_last_visit_date = "Last Visit Date"
    case profile_reseller = "(Reseller)"
    case profile_sub_account = "(Sub account)"
    case profile_sign_out = "Sign Out"
    case profile_signing_out = "Signing Out…"
    
    case agreement_reseller = "Reseller agreement"
    case agreement_terms_of_use = "You should read carefully the following terms and conditions of reseller agreement before using our system to ensure maximum privacy and confidentiality with Bitaqaty Business :"
    case agreement_copyright_notice_header = "Copyright notice"
    case agreement_copyright_notice = "All copy rights reserved to National Technology Group (NTG)"
    case agreement_logos_and_trademarks_header = "Logos and trademarks"
    case agreement_logos_and_trademarks = "Bitaqaty Business is a registered trademark of NTG"
    case agreement_reseller_services_header = "Reseller services"
    case agreement_reseller_services = "Resellers may sell services and products provided by Bitaqaty Business at discount rates lists. All services featured on this website are available as per signed contracts with owners. Reproduction or republication of any included services is prohibited without prior consent of Bitaqaty Business. Bitaqaty Business is entitled to change available rates, according to market prices, without prior notification to distributor. Rates will be updated in the discounts and offers box within the reseller’s account page on Bitaqaty Business"
    case agreement_privacy_and_confidentiality_header = "Privacy and confidentiality"
    case agreement_privacy_and_confidentiality = "Bitaqaty Business is committed to protecting user privacy. No reseller is entitled to disclose any private data included in his/her account to a third party, including Bitaqaty Business team or technical support team. In this case, Bitaqaty Business shall not be held liable for any repercussions thereof. Using your account on Bitaqaty Business means you have credit account on Bitaqaty Business.net. Accordingly, user account should include valid data to ensure password recovery in case it is lost or forgotten. Should invalid data be registered with, Bitaqaty Business shall not be committed to account loss or recovery. Essential data include the following: mobile number, email address, username and address. In case of any change in reseller’s data, the user shall be responsible for updating his/her account details on Bitaqaty Business. In case of any account abuse, Bitaqaty Business has the sole right to suspend user’s account without prior notification. Logging in to your Bitaqaty Business account should be only done through the following link: https://www.Bitaqaty Business.net. Bitaqaty Business will not bear responsibility for illegal logins to Bitaqaty Business accounts Inactive accounts will be handled in accordance with Bitaqaty Business policy in this regards."
    case agreement_agree = "Agree"
    
    case more_manage_sub_account = "Manage Sub Accounts"
    case more_reports = "Reports"
    case more_resellers_support_center = "Resellers Support Center"
    case more_sales_report = "Sales report"
    case more_faq = "FAQ"
    case more_terms_of_use = "Terms of Use"
    case more_privacy_policy = "Privacy Policy"
    case more_terms_of_use_overview = "Welcome to bitaqatybusiness.com Website “Bitaqaty Business”. Please read the following terms and conditions:\n\nBy accessing, registering and/or continuing to use or access the Website, you are agreeing to be bound by these Terms of Use and the other documents and terms with immediate effect.\nThese Terms of Use and the Legal Documents are subject to change by us at any time. Your continued use of the Website following any such change constitutes your agreement to these Terms of Use and Legal Documents as so modified.\n\nABOUT THE WEBSITE\nThe Website is an e-commerce platform that allows users to purchase a wide variety of cards and digital services.\nBITAQATY BUSINESS reserves the right to introduce new services and update or withdraw any of the services, in our sole discretion without any liability. "
    case more_privacy_policy_overview = "Bitaqaty Business takes the privacy of your personal information very seriously, and by accepting this Privacy Policy, you expressly consent to us collecting, using and disclosing your personal information only in accordance with this Privacy Policy. Please note that Bitaqaty Business does not sell, rent or license your personal information to anyone."
    
    
    var localizedValue: String{
        switch self {
        case .sign_welcome:
            if (lang == "ar"){
                return "مرحبا بك\nفي بطاقاتي أعمال";
            }
            return self.rawValue;
        case .send:
            if (lang == "ar"){
                return "إرسال";
            }
            return self.rawValue;
        case .code:
            if (lang == "ar"){
                return "الكود";
            }
            return self.rawValue;
        case .sign_in:
            if (lang == "ar"){
                return "تسجيل الدخول";
            }
            return self.rawValue;
        case .sign_dots:
            return self.rawValue;
        case .english:
            return self.rawValue;
        case .arabic:
            return self.rawValue;
            
        case .sign_instruction:
            if (lang != "en") {
                return "للقيام بتسجيل الدخول , يرجى إدخال البريد الإلكتروني و كلمة السر الخاصيين بك ثم انقر تسجيل الدخول";
            }
            return self.rawValue;
        case .sign_username:
            if (lang != "en") {
                return "البريد الإلكتروني/إسم المستخدم*";
            }
            return self.rawValue;
        case .sign_password:
            if (lang != "en") {
                return "كلمه السر*";
            }
            return self.rawValue;
        case .sign_forgot_password:
            if (lang != "en") {
                return "نسيت كلمة السر ؟";
            }
            return self.rawValue;
        case .sign_signing:
            if (lang != "en") {
                return "جارى تسجيل الدخول…";
            }
            return self.rawValue;
            
        case .pass_enter_new_password:
            if (lang != "en") {
                return "أدخل كلمة سر جديدة";
            }
            return self.rawValue;
        case .pass_instruction:
            if (lang != "en") {
                return "يرجى إدخال كلمة السر الجديدة و تأكيد كلمة السر الجديدة ثم انقر تغيير";
            }
            return self.rawValue;
        case .pass_change:
            if (lang != "en") {
                return "تغيير";
            }
            return self.rawValue;
        case .pass_current_pass:
            if (lang != "en") {
                return "كلمة السر الحالية*";
            }
            return self.rawValue;
        case .pass_new_pass:
            if (lang != "en") {
                return "كلمة السر الجديدة*";
            }
            return self.rawValue;
        case .pass_conf_new_pass:
            if (lang != "en") {
                return "تأكيد كلمة السر الجديدة*";
            }
            return self.rawValue;
        case .pass_validation_1:
            if (lang != "en") {
                return "يجب أن تكتب باللغة اﻹنجليزية";
            }
            return self.rawValue;
        case .pass_validation_2:
            if (lang != "en") {
                return "تحتوي على 8 أحرف كحد أدنى";
            }
            return self.rawValue;
        case .pass_validation_4:
            if (lang != "en") {
                return "تحتوي على حرف كبير على اﻷقل";
            }
            return self.rawValue;
        case .pass_validation_3:
            if (lang != "en") {
                return "تحتوي على حرف صغير على اﻷقل";
            }
            return self.rawValue;
        case .pass_validation_5:
            if (lang != "en") {
                return "تحتوي على رقم";
            }
            return self.rawValue;
        case .pass_applying_change:
            if (lang != "en") {
                return "جارى التغيير …";
            }
            return self.rawValue;
        case .pass_change_success:
            if (lang != "en") {
                return "تم تغيير كلمة السر بنجاح, يمكنك تسجيل الدخول اﻵن بكلمة السر الجديدة";
            }
            return self.rawValue;
            
        case .reset_password:
            if (lang != "en") {
                return "إستعادة كلمة السر";
            }
            return self.rawValue;
        case .reset_instruction:
            if (lang != "en") {
                return "لاستعادة كلمة السر الخاصة بك، يرجى ادخال البريد الإلكتروني أو اسم المستخدم  الخاص بك، ثم انقر إرسال, سوف يقوم النظام بإرسال رسالة تحتوى على كود التحقيق .قم باستخدام هذا الكود لتغيير كلمة السر الخاصة بك ,ملحوظة هذا الكود صالح لمدة السر الخاصة بك  ,ملحوظة هذا الرابط صالح لمدة ساعة";
            }
            return self.rawValue;
        case .reset_email:
            if (lang != "en") {
                return "عنوان البريد الإلكتروني / اسم المستخدم *";
            }
            return self.rawValue;
        case .reset_resend:
            if (lang != "en") {
                return "إعادة إرسال الرابط";
            }
            return self.rawValue;
        case .reset_link_sent:
            if (lang != "en") {
                return "تم إعادة إرسال الرابط";
            }
            return self.rawValue;
        case .reset_success_msg:
            if (lang != "en") {
                return "تم إرسال رابط إعادة تعيين كلمة السر إلى EMAIL_TXT لإعادة تعيين كلمة سر جديدة, من فضلك قم بالضغط على الرابط المرسل من بطاقاتى \n\n للحصول على المساعدة, يمكنك الإتصال بخدمة موزعى بطاقاتى أعمال الآن \n\n\n إن لم تصلك الرسالة, يمكنك إعادة إرسال الرابط";
            }
            return self.rawValue;
            
        case .verification_enter_code:
            if (lang != "en") {
                return "أدخل كود التحقيق";
            }
            return self.rawValue;
        case .verification_instruction:
            if (lang != "en") {
                return "يرجى إدخال كود التحقيق المرسل لرقم الجوال الخاص بحسابك ثم انقر تسجيل الدخول";
            }
            return self.rawValue;
        case .verification_code:
            if (lang != "en") {
                return "كود التحقيق";
            }
            return self.rawValue;
        case .verification_resend:
            if (lang != "en") {
                return "ارسال مرة اخري";
            }
            return self.rawValue;
        case .verification_resend_message:
            if (lang != "en") {
                return "في حالة لم تستقبل كود التحقيق اضغط";
            }
            return self.rawValue;
            
        case .verification_trial:
            if (lang != "en") {
                return "محاولة";
            }
            return self.rawValue;
        case .verification_wait:
            if (lang != "en") {
                return "انتظر";
            }
            return self.rawValue;
        case .verification_seconds:
            if (lang != "en") {
                return "ثانية";
            }
            return self.rawValue;
        case .verification_verifying:
            if (lang != "en") {
                return "جاري التحقق …";
            }
            return self.rawValue;
        case .verification_code_sent:
            if (lang != "en") {
                return "تم ارسال كود التحقق";
            }
            return self.rawValue;
            
        case .profile_account_no:
            if (lang != "en") {
                return "رقم الحساب";
            }
            return self.rawValue;
        case .profile_last_visit_date:
            if (lang != "en") {
                return "تاريخ آخر زيارة";
            }
            return self.rawValue;
        case .profile_reseller:
            if (lang != "en") {
                return "(موزع)";
            }
            return self.rawValue;
        case .profile_sub_account:
            if (lang != "en") {
                return "(حساب فرعي)";
            }
            return self.rawValue;
        case .profile_sign_out:
            if (lang != "en") {
                return "تسجيل الخروج";
            }
            return self.rawValue;
        case .profile_signing_out:
            if (lang != "en") {
                return "جارى تسجيل خروج…";
            }
            return self.rawValue;
        case .agreement_reseller:
            if (lang != "en") {
                return "إتفاقية الإستخدام للموزعين";
            }
            return self.rawValue;
            
        case .agreement_terms_of_use:
            if (lang != "en") {
                return "يجب قراءة اتفاقية الاستخدام بنظام إعادة البيع الخاص بالموزعين بعناية قبل البدء باستخدام النظام وذلك لضمان أعلى درجة في الحماية والسرية من خلال تعاملكم مع موقع بطاقاتي بيزنس:";
            }
            return self.rawValue;
        case .agreement_copyright_notice_header:
            if (lang != "en") {
                return "حقوق النشر والطبع";
            }
            return self.rawValue;
        case .agreement_copyright_notice:
            if (lang != "en") {
                return "جميع حقوق الطبع والنشر وفكرة بطاقاتي بيزنس تابعة للمجموعة الوطنية للتقنية";
            }
            return self.rawValue;
        case .agreement_logos_and_trademarks_header:
            if (lang != "en") {
                return "الشعارات والعلامة التجارية";
            }
            return self.rawValue;
        case .agreement_logos_and_trademarks:
            if (lang != "en") {
                return "علامة بطاقاتي بيزنس التجارية هي علامة تجارية مسجلة باسم المجموعة الوطنية للتقنية";
            }
            return self.rawValue;
        case .agreement_reseller_services_header:
            if (lang != "en") {
                return "خدمات نظام الموزعين";
            }
            return self.rawValue;
        case .agreement_reseller_services:
            if (lang != "en") {
                return "يحق للموزع إعادة بيع جميع الخدمات و المنتجات التي يقدمها موقع بطاقاتي بيزنس بنسب الخصم الموضحة في جدول نسب الخصم الخاصة بنظام الموزعين، جميع الخدمات المدرجة بـ بطاقاتي بيزنس هي مدرجة باتفاق وعقود مع اصحابها ولا يحق لأحد الاقتباس من الموقع دون الرجوع إلى إدارة الموقع.يحق لبطاقاتي بيزنس بتغير نسبة اي وقت حسب اسعار السوق و بدون إعطاء اشعار مسبق للموزع, على ان يتم تحديث هذه النسب في جدول نسب الخصم الخاص بالموزعين و العروض داخل حسابالموزع على موقع بطاقاتي بيزنس";
            }
            return self.rawValue;
        case .agreement_privacy_and_confidentiality_header:
            if (lang != "en") {
                return "الأمان والسرية";
            }
            return self.rawValue;
        case .agreement_privacy_and_confidentiality:
            if (lang != "en") {
                return "جميع البيانات الموجودة بالموقع تعامل معاملة سرية تامة ، ولا يحق لأي موزع إعطاء أي معلومات سرية خاصة بحسابه لأي شخص و من ضمنهم فريق بطاقاتي بيزنس و الدعم الفني التابع لفريق بطاقاتي بيزنس ، وفي حال حصل غير ذلك فإن بطاقاتي بيزنس غير مسؤول عن اي نتائج ومترتبات تحصل جراء ذلك. فيجب على كل مستخدم تسجيل كآفة البيانات الصحيحة الخاصة به في الحساب والتي تضمن له استرجاع الرقم السري في حال فقدانه أو نسيانه ، وفي حالة عدم تسجيله فإن بطاقاتي بيزنس غير مسؤول تماماً عن أي فقدان الحساب من جراء عدم تسجيل كآفة البينات الصحيحة ، ولن يلتزم المسؤولون بـ بطاقاتي بيزنس باسترداد أي حساب للعميل ( البيانات الهامة هي : رقم الجوال ، الإيميل ، اسم صاحب الحساب ،عنوان صاحب الحساب ) في حال حصول أي تغيير في البيانات الخاصة بالموزع فإن صاحب الحساب هو المسؤول عن تحديث بياناته لدى الموقع ولن يتم النظر في أي حساب لن يتم تحديثه ، وسيتم التعامل مع صاحب الحساب حسب آخر بيانات مدخلة بـ بطاقاتي بيزنس. إن أي إساءة في استخدام الحساب الخاص بك يعرض الحساب للإيقاف دون الرجوع إلى صاحب الحساب ، وهو حق خاص بـ بطاقاتي بيزنس. الدخول لموقع بطاقاتي بيزنس عبر الوصلة التالية فقط : - https://www.Bitaqaty Business.net ، وأي دخول على غير هذه العناوين يعتبر دخول غير شرعي ويعتبر بطاقاتي بيزنس غير مسؤول عن أي نتائج مترتبة جراء ذلك. ستتم التعامل مع الحسابات الغير مفعلة حسب السياسة التي يراها المسؤولين على بطاقاتي بيزنس في التعامل مع نوعية هذه الحسابات.";
            }
            return self.rawValue;
        case .agreement_agree:
            if (lang != "en") {
                return "موافق";
            }
            return self.rawValue;
            
        case .more_manage_sub_account:
            if (lang != "en") {
                return "إدارة الحسابات الفرعية";
            }
            return self.rawValue;
        case .more_reports:
            if (lang != "en") {
                return "التقارير";
            }
            return self.rawValue;
        case .more_resellers_support_center:
            if (lang != "en") {
                return "خدمة الموزعين";
            }
            return self.rawValue;
        case .more_sales_report:
            if (lang != "en") {
                return "تقرير المبيعات";
            }
            return self.rawValue;
        case .more_faq:
            if (lang != "en") {
                return "الأسئلة الأكثر شيوعاً";
            }
            return self.rawValue;
        case .more_terms_of_use:
            if (lang != "en") {
                return "شروط الإستخدام";
            }
            return self.rawValue;
        case .more_privacy_policy:
            if (lang != "en") {
                return "سياسة الخصوصية";
            }
            return self.rawValue;
        case .more_terms_of_use_overview:
            if (lang != "en") {
                return "نرحب بك في موقع الإلكتروني 'بطاقاتي أعمال' 'BITAQATYBUSINESS.COM' ونرجو منك الاطلاع على الشروط والأحكام التالية :\n\nفي حال وصولك للموقع أو تسجيلك أو استمرارك في استخدام الموقع أو الوصول إليه، فأنت توافق على الالتزام بشروط الاستخدام هذه والوثائق والشروط الأخرى بأثر فوري\nان شروط الاستخدام هذه والوثائق القانونية خاضعة للتعديل من قبلنا في اي وقت. إن استمرار استخدامك للموقع بعد نشر أي تغيير يعني موافقتك على شروط الاستخدام هذه والوثائق القانونية التي تم تعديلها \n\nنُبذة عن الموقع \nيعد هذا الموقع متجر إلكتروني يتيح للمستخدمين شراء مجموعة متنوعة من البطاقات و الخدمات الرقميه.تحتفظ بطاقاتي أعمال بحق تقديم خدمات جديدة وتحديث أي من الخدمات أو سحبها، وفقاً لتقديرنا الخاص دون اية مسؤولية";
            }
            return self.rawValue;
        case .more_privacy_policy_overview:
            if (lang != "en") {
                return "تلتزم بطاقاتى أعمال إلى أقصى درجة بحماية بياناتك الشخصية، ومن خلال قبولكم لسياسة الخصوصية الخاصة بعملاء بطاقاتى أعمال، فإنكم تسمحون لنا بجمع واستخدام والكشف عن المعلومات الشخصية الخاصة بك فقط وفقا لسياسة الخصوصية وبشكل محدود جداً. يرجى العلم بأنه لن يتم أبدا بيع أو استخدام أو عرض بياناتك الشخصية إلى أية جهة بمقابل أو بدون ";
            }
            return self.rawValue;
        }
    }
}
