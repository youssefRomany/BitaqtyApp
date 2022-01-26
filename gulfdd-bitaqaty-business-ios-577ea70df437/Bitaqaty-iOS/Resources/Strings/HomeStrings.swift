//
//  HomeStrings.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 11/10/2021.
//

import Foundation
enum HomeStrings: String{
    case welcome = "Welcome to Bitaqaty Business"
    case daily_sales = "Daily Sales"
    case daily_recharge = "Daily Recharge"
    case average_sales_this_month = "Average Sales this month"
    case average_sales_last_month = "Average Sales last month"
    case homeDays = "Days"
    case remaining = "Remaining for the balance to run out"
    case averageLast7Days = "Average Sales Last 7 Days"
    case home_this_month = "This Month"
    case home_last_month = "Last Month"
    case home_yesterday = "Yesterday"
    case home_last_week = "Last 7 days"
    case home_Today = "Today"
    case homeSales = "Sales"
    case recharge_now = "Recharge now"
    case subaccounts = "Sub Accounts"
    case manage_all = "Manage All"
    case sales_report = "Sales Report"
    case home_sales = "(Sales)"
    case yourTopSelling = "Your Top Selling Products"
    case bank_transfer_recharging_requests = "Bank Transfer Recharging Requests"
    case newBankTransfere = "New Bank Transfer"
    case total_Sales = "Total Sales"
    case home_recharge_amount = "Recharge amount"
    case view_all = "View all"
    case total = "Total"
    case tranaction_log = "Transaction log"
    case printed = "Printed"
    
    var localizedValue: String{
        switch self {
        case .daily_sales:
            if (lang != "en") {
                return "المبيعات اليومية"
            }
            return self.rawValue
        case .daily_recharge:
            if (lang != "en") {
                return "الشحن اليومي"
            }
            return self.rawValue
        case .average_sales_this_month:
            if (lang != "en") {
                return "متوسط مبيعات هذا الشهر "
            }
            return self.rawValue
        case .average_sales_last_month:
            if (lang != "en") {
                return "متوسط مبيعات الشهر السابق"
            }
            return self.rawValue
        case .homeDays:
            if (lang != "en") {
                return "يوم"
            }
            return self.rawValue
        case .remaining:
            if (lang != "en") {
                return "باقي على نفاذ الرصيد"
            }
            return self.rawValue
        case .averageLast7Days:
            if (lang != "en") {
                return "متوسط مبيعات آخر 7 أيام"
            }
            return self.rawValue
        case .home_this_month:
            if (lang != "en") {
                return "هذا الشهر"
            }
            return self.rawValue
        case .home_last_month:
            if (lang != "en") {
                return "الشهر السابق"
            }
            return self.rawValue
        case .home_yesterday:
            if (lang != "en") {
                return "بالأمس"
            }
            return self.rawValue
        case .home_last_week:
            if (lang != "en") {
                return "آخر 7 أيام"
            }
            return self.rawValue
        case .home_Today:
            if (lang != "en") {
                return "اليوم"
            }
            return self.rawValue
        case .recharge_now:
            if (lang != "en") {
                return "إشحن الآن"
            }
            return self.rawValue
        case .subaccounts:
            if (lang != "en") {
                return "الحسابات الفرعية"
            }
            return self.rawValue
        case .manage_all:
            if (lang != "en") {
                return "إدارة الكل"
            }
            return self.rawValue
        case .sales_report:
            if (lang != "en") {
                return "تقرير المبيعات"
            }
            return self.rawValue
        case .home_sales:
            if (lang != "en") {
                return "(المبيعات)"
            }
            return self.rawValue
        case .yourTopSelling:
            if (lang != "en") {
                return "منتجاتك الأكثر مبيعا"
            }
            return self.rawValue
        case .bank_transfer_recharging_requests:
            if (lang != "en") {
                return "طلبات شحن التحويل البنكي"
            }
            return self.rawValue
        case .newBankTransfere:
            if (lang != "en") {
                return "تحويل بنكي جديد"
            }
            return self.rawValue
        case .total_Sales:
            if (lang != "en") {
                return "إجمالي المبيعات"
            }
            return self.rawValue
        case .home_recharge_amount:
            if (lang != "en") {
                return "مبلغ الشحن"
            }
            return self.rawValue
        case .homeSales:
            if (lang != "en") {
                return "المبيعات"
            }
            return self.rawValue
        case .view_all:
            if (lang != "en") {
                return "عرض الكل"
            }
            return self.rawValue
        case .total:
            if (lang != "en") {
                return "الإجمالي"
            }
            return self.rawValue
        case .tranaction_log:
            if (lang != "en") {
                return "سجل العمليات"
            }
            return self.rawValue
        case .printed:
            if (lang != "en") {
                return "تمت الطباعة"
            }
            return self.rawValue
        case .welcome:
            if (lang != "en"){
                return "مرحبا في بطاقاتي أعمال";
            }
            return self.rawValue;
        }
    }
}
