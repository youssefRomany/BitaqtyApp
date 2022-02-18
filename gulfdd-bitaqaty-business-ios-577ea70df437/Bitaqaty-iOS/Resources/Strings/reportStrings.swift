//
//  reportStrings.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import Foundation
enum reportStrings: String{
    case username = "Username";
    case category = "Category";
    case service = "Service";
    case product = "Product Name";
    case date = "Date";
    case channel = "Channel";
    case total_cost_price = "Total Cost Price";
    case no_of_transactions = "No. of Transactions";
    case show_sales_in_sub_account_price = "Show Sales in Sub Account Price"
    case show_sales_in_recommended_retail_price = "Show Sales in Recommended Retail Price";
    case trans_no = "Trans. No.";
    case cost_price = "Cost Price";
    case recommended_retail_price = "Recommended Retail Price";
    case total_recommended_retail_price = "Total Recommended Retail Price";
    case total_profit = "Total Profit";
    case sub_account_price = "Sub Account Price";
    case total_sub_account_price = "Total Sub Account Price";
    case total_expected_profit = "Total Expected Profit";
    case all = "All";
    case this_month = "This Month";
    case last_month = "Last Month";
    case yesterday = "Yesterday";
    case last_week = "Last 7 days";
    case today = "Today";
    case custom_date = "Custom date";
    case portal = "Portal";
    case pos = "POS";
    case integration = "Integration";
    case wallet = "Wallet";
    case export_file_name = "Sales Report.csv";
    
    var localizedValue: String{
        switch self {
        case .username:
            if (lang != "en") {
                return "اسم المستخدم"
            }
            return self.rawValue
        case .category:
            if (lang != "en") {
                return "التصنيف"
            }
            return self.rawValue
        case .service:
            if (lang != "en") {
                return "الخدمة"
            }
            return self.rawValue
        case .product:
            if (lang != "en") {
                return "اسم المنتج"
            }
            return self.rawValue
        case .date:
            if (lang != "en") {
                return "التاريخ"
            }
            return self.rawValue
        case .channel:
            if (lang != "en") {
                return "القناة"
            }
            return self.rawValue
        case .total_cost_price:
            if (lang != "en") {
                return "إجمالي سعر التكلفة"
            }
            return self.rawValue
        case .no_of_transactions:
            if (lang != "en") {
                return "عدد العمليات"
            }
            return self.rawValue
        case .trans_no:
            if (lang != "en") {
                return "العدد"
            }
            return self.rawValue
        case .cost_price:
            if (lang != "en") {
                return "سعر التكلفة"
            }
            return self.rawValue
        case .all:
            if (lang != "en") {
                return "الكل"
            }
            return self.rawValue
        case .this_month:
            if (lang != "en") {
                return "هذا الشهر"
            }
            return self.rawValue
        case .last_month:
            if (lang != "en") {
                return "الشهر السابق"
            }
            return self.rawValue
        case .yesterday:
            if (lang != "en") {
                return "بالأمس"
            }
            return self.rawValue
        case .last_week:
            if (lang != "en") {
                return "آخر 7 أيام"
            }
            return self.rawValue
        case .today:
            if (lang != "en") {
                return "اليوم"
            }
            return self.rawValue
        case .custom_date:
            if (lang != "en") {
                return "تاريخ محدد"
            }
            return self.rawValue
        case .portal:
            if (lang != "en") {
                return "الموقع الإلكتروني"
            }
            return self.rawValue
        case .pos:
            if (lang != "en") {
                return "نقطة البيع"
            }
            return self.rawValue
        case .integration:
            if (lang != "en") {
                return "ربط خارجي"
            }
            return self.rawValue
        case .wallet:
            if (lang != "en") {
                return "المحفظة"
            }
            return self.rawValue
        case .export_file_name:
            if (lang != "en") {
                return "تقرير المبيعات.csv"
            }
            return self.rawValue
        case .show_sales_in_recommended_retail_price:
            if (lang != "en") {
                return "إظهار المبيعات بسعر البيع المقترح"
            }
            return self.rawValue
        case .total_recommended_retail_price:
            if (lang != "en") {
                return "إجمالي سعر البيع المقترح"
            }
            return self.rawValue
        case .total_expected_profit:
            if (lang != "en") {
                return "إجمالي الربح المتوقع"
            }
            return self.rawValue
        case .recommended_retail_price:
            if (lang != "en") {
                return "سعر البيع المقترح"
            }
            return self.rawValue
        case .show_sales_in_sub_account_price:
            if (lang != "en") {
                return "إظهار المبيعات بسعر الحساب الفرعي"
            }
            return self.rawValue
        case .total_profit:
            if (lang != "en") {
                return "إجمالي الربح"
            }
            return self.rawValue
        case .sub_account_price:
            if (lang != "en") {
                return "سعر الحساب الفرعي"
            }
            return self.rawValue
        case .total_sub_account_price:
            if (lang != "en") {
                return "إجمالي سعر الحساب الفرعي"
            }
            return self.rawValue
        }
    }
}
