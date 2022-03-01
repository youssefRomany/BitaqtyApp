//
//  Report.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import Foundation

struct Report: Codable {
    var subAccountName: String? = nil
    var merchantNameAr: String? = nil
    var merchantNameEn: String? = nil
    var productNameAr: String? = nil
    var productNameEn: String? = nil
    var price: Double? = nil
    var numberOfTrans: Int? = nil
    var numberOfTransForRecommendedPrice: Double? = nil
    var totalTransAmount: Double? = nil
    var productSalesPercentage: String? = nil
    var logoPath: String? = nil
    var productId: Int? = nil
    var recommendedPrice: Double? = nil
    var totalRecommendedPrice: Double? = nil
    var totalExpectedProfit: String? = nil
    var totalTransAmountForRecommendedPrice: Double? = nil

    var subResellerPrice: Double? = nil
    var totalSubResellerPrice: Double? = nil
    var totalProfit: String? = nil
    var totalTransAmountForSubResellerPrice: Double? = nil

    
    
    func getMerchantName()-> String{
        if (lang == "en"){
            return merchantNameEn ?? merchantNameAr ?? ""
        }else{
            return merchantNameAr ?? merchantNameEn ?? ""
        }
    }
    func getProductName()-> String{
        if (lang == "en"){
            return productNameEn ?? productNameAr ?? ""
        }else{
            return productNameAr ?? productNameEn ?? ""
        }
    }
    func getPercentage()-> Double{
        if productSalesPercentage != nil && productSalesPercentage != "N/A"{
            return (productSalesPercentage! as NSString).doubleValue
        }
        return 0.0
    }
}
