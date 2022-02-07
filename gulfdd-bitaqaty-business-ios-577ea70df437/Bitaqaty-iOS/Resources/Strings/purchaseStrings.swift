//
//  purchaseStrings.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import Foundation
enum purchaseStrings: String {
    case shopping_categories = "Shopping categories";
    case seeMore = "See more";
    case how_to_use = "How to use";
    case total_cost_price = "Total Cost Price";
    case vat_amount_per = "VAT Amount (%)";
    case total_cost_after_vat = "Total Cost after VAT";
    case buy = "Buy";
    case purchase_success = "New product has been purchased successfully";
    case purchase_date = "Purchasing date";
    case quantity = "Quantity";
    case choose_method = "Please choose your favorite method";
    case proceed = "Proceed";
    case print = "Print Product";
    case share = "Share";
    case reprint = "Do you want to reprint ?";
    case second_copy = "Second Copy";
    case product_cost_price = "Product Cost Price";
    case date = "Date";
    case product = "Product:";
    case recommended_cost_price = "Recommended Retail Price"
    case totalRecommended_cost_price = "Total Recommended Retail Price"
    case totalRecommended_cost_price_after_vat = "Total Recommended Retail Price after VAT"

    var localizedValue: String{
        switch self {
        case .shopping_categories:
            if (lang != "en") {
                return "أقسام الشراء"
            }
        case .seeMore:
            if (lang != "en") {
                return "المزيد"
            }
        case .how_to_use:
            if (lang != "en") {
                return "كيفية الإستخدام"
            }
        case .total_cost_price:
            if (lang != "en") {
                return "إجمالي سعر التكلفة"
            }
        case .vat_amount_per:
            if (lang != "en") {
                return "مبلغ الضريبة (%)"
            }
        case .total_cost_after_vat:
            if (lang != "en") {
                return "إجمالي التكلفة بعد الضريبة"
            }
        case .buy:
            if (lang != "en") {
                return "شراء"
            }
        case .purchase_success:
            if (lang != "en") {
                return "تم بنجاح شراء منتج جديد"
            }
        case .purchase_date:
            if (lang != "en") {
                return "تاريخ الشراء"
            }
        case .quantity:
            if (lang != "en") {
                return "الكمية"
            }
        case .choose_method:
            if (lang != "en") {
                return "اختر الطريقة التي تفضلها"
            }
        case .proceed:
            if (lang != "en") {
                return "تابع"
            }
        case .print:
            if (lang != "en") {
                return "طباعة المنتج"
            }
        case .share:
            if (lang != "en") {
                return "مشاركة"
            }
        case .reprint:
            if (lang != "en") {
                return "هل تريد إعادة الطباعة ؟"
            }
        case .second_copy:
            if (lang != "en") {
                return "نسخة تانية"
            }
        case .product_cost_price:
            if (lang != "en") {
                return "سعر تكلفة المنتج"
            }
        case .date:
            if (lang != "en") {
                return "التاريخ:"
            }
        case .product:
            if (lang != "en") {
                return "المنتج:"
            }
        case .recommended_cost_price:
            if (lang != "en") {
                return "سعر البيع المقترح"
        }
            
        case .totalRecommended_cost_price:
            if (lang != "en") {
                return "إجمالي سعر البيع المقترح"
        }
        case .totalRecommended_cost_price_after_vat:
            if (lang != "en") {
                return "إجمالي سعر البيع المقترح بعد إضافة الضريبة"
        }
            
        }
        return self.rawValue

    }
}
