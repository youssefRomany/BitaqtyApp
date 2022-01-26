//
//  supportStrings.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/17/21.
//

import Foundation

enum supportStrings: String{
    case choose_ticket_type = "Please choose the ticket type*";
    case full_name = "Full Name";
    case email_address = "Email address*";
    case mobile_no = "Mobile Number";
    case ticket_details = "Ticket Details*";
    case how_to = "How to make a ticket";
    case how_to_1 = "Kindly use Bitaqaty Business Live Chat only which is available now on Bitaqaty Business website.";
    case how_to_2 = "Ask away… we are here to help! Just fill in the form and we will do our best to get back to you within 24 hours. It might take a bit longer – depending on the question, but we try hard not to keep you waiting longer than 72 hours.";
    case how_to_3 = "For the meantime, please have a look at our FAQ You may find the answer for your question right there!";
    case how_to_4 = "Please choose a topic and subtopic from the list below, and be as specific as possible in the data you enter";
    case talk_with_support_team = "Talk with Resellers Support Team";
    case successful_message = "Thank you for contacting us, will be replied within an hour, Please note that the working hours are from 9 am to 2 am";
    case chat = "Chat";
    case or = "Or";
    case whats_app = "Whatsapp";
    case whats_no = "+966597206666";
    case email = "support@bitaqatybusiness.com";
    
    var localizedValue: String{
        if (lang != "en"){
            switch self {
            case .choose_ticket_type:
                return "من فضلك اختر نوع الطلب*";
            case .full_name:
                return "الإسم بالكامل";
            case .email_address:
                return "البريد الإلكتروني*";
            case .mobile_no:
                return "رقم الجوال";
            case .ticket_details:
                return "تفاصيل التذكرة*";
            case .how_to:
                return "كيفية عمل تذكرة";
            case .how_to_1:
                return "نرجو إستخدام نظام الدردشة الموجود حاليا على موقع 'بطاقاتي أعمال' فقط";
            case .how_to_2:
                return "يرجى تعبئة الاستمارة و سنرد على استفسارك خلال 24 ساعة أو أقل، على حسب استفسارك.";
            case .how_to_3:
                return "يمكنك مراجعة قسم الأسئلة الأكثر شيوعاً في الوقت الحالي، فقد تجد إجابة على سؤالك!";
            case .how_to_4:
                return "اختر نوع الحساب وطبيعة المشكلة من القوائم المنسدلة التالية، برجاء تحرى الدقة أثناء إدخال البيانات";
            case .talk_with_support_team:
                return "تحدث إلى خدمة الموزعين";
            case .successful_message:
                return "شكرا لتواصلك معنا, سيتم الرد في خلال ساعة , يرجى العلم بأن مواعيد العمل من 9 صباحا حتى 2 صباحا";
            case .chat:
                return "محادثة";
            case .whats_app:
                return "واتس اب";
            case .or:
                return "أو";
            default:
                return self.rawValue
            }
        }else{
            return self.rawValue
        }
    }
}
