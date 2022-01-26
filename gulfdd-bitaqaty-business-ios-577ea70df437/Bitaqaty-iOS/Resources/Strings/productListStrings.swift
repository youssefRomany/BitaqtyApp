//
//  productListStrings.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import Foundation
enum productListStrings: String{
      case category = " Category "
      case service = " Service "
      case VAT_Amount = "VAT Amount"
      case costAfterVat = "Cost Price after VAT"
      case costPrice = "Cost Price"
      case productName = "Product Name"
      case ProductListSheetName = "Products_Discounts_List"
      case exportedProductListFileName = "Products_Discounts_List.csv"

      case search_desc = "Enter a few words to search on Bitaqaty business"
      case search_results_for = "Search results for:"
      case no_results_found = "No results found for: "
      case product_cost_price = "Product Cost Price"
      case out_of_stock = "Out of stock"
      case productSearchHint = "Search"
    
    var localizedValue: String{
        switch self {
        case .category:
            if (lang != "en") {
                return " التصنيف "
            }
            return self.rawValue
        case .service:
            if (lang != "en") {
                return " الخدمة "
            }
            return self.rawValue
        case .VAT_Amount:
            if (lang != "en") {
                return "مبلغ الضريبة"
            }
            return self.rawValue
        case .productName:
            if (lang != "en") {
                return "اسم المنتج"
            }
            return self.rawValue
        case .costAfterVat:
            if (lang != "en") {
                return "سعر التكلفة بعد الضريبة"
            }
            return self.rawValue
        case .costPrice:
            if (lang != "en") {
                return "سعر التكلفة "
            }
            return self.rawValue
        case .ProductListSheetName:
            if (lang != "en") {
                return "قائمة_خصومات المنتجات"
            }
            return self.rawValue
        case .exportedProductListFileName:
            if (lang != "en") {
                return "قائمة_خصومات_المنتجات.csv"
            }
            return self.rawValue
        case .search_desc:
            if (lang != "en") {
                return "ادخل بعض الكلمات للبحث في بطاقاتي أعمال"
            }
            return self.rawValue
        case .search_results_for:
            if (lang != "en") {
                return "نتائج البحث عن"
            }
            return self.rawValue
        case .no_results_found:
            if (lang != "en") {
                return "لا توجد نتائج ل "
            }
            return self.rawValue
        case .product_cost_price:
            if (lang != "en") {
                return "سعر تكلفة المنتج"
            }
            return self.rawValue
        case .out_of_stock:
            if (lang != "en") {
                return "غير متاح"
            }
            return self.rawValue
        case .productSearchHint:
            if (lang != "en") {
                return "بحث "
            }
            return self.rawValue
        }
    }
}

