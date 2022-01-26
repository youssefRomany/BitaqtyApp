//
//  ProductDetails.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import Foundation
struct ProductDetails: Codable {
    var errors: [ErrorMessage]? = nil
    var products: [ProductData]? = nil
    var vatAmount: String? = nil
    var totalVatAmount: String? = nil
    var oneItemPriceBeforeVat: String? = nil
    var totalItemsPriceBeforeVat: String? = nil
    var oneItemPriceAfterVat: String? = nil
    var totalItemsPriceAfterVat: String? = nil
    var itemsCount: Int? = 0
    var purchaseDate: String? = nil
    var purchaseDateTime: String? = nil
    var vatPercentage: String? = nil
    var productId: Int? = nil
    
    init(error: ErrorMessage) {
        errors = [error]
    }
}

struct ProductData: Codable {
    var productSerial: String? = nil
    var productUsername: String? = nil
    var productPassword: String? = nil
    var productSecret: String? = nil
    var transRefNumber: String? = nil
    var productUsernameTitleEn: String? = nil
    var productSerialTitleEn: String? = nil
    var productSecretTitleEn: String? = nil
    var productUsernameTitleAr: String? = nil
    var productSerialTitleAr: String? = nil
    var productSecretTitleAr: String? = nil
    var barcode: String? = nil
    var receiptPrintDetailsEn: String? = nil
    var receiptPrintDetailsAr: String? = nil
    var enableReceiptDetails: Bool? = false
    var isItunesMerchant: Bool? = false
    
    func getUserNameTitle() -> String{
        if (lang == "en"){
            return productUsernameTitleEn ?? ""
        }else{
            return productUsernameTitleAr ?? ""
        }
    }
    
    func getUserSecretTitle() -> String{
        if (lang == "en"){
            return productSecretTitleEn ?? ""
        }else{
            return productSecretTitleAr ?? ""
        }
    }
    func getSerialTitle() -> String{
        if (lang == "en"){
            return productSerialTitleEn ?? ""
        }else{
            return productSerialTitleAr ?? ""
        }
    }
}
