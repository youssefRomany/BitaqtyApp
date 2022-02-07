//
//  TransactionLog.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/21/21.
//

import Foundation
struct TransactionLog : Codable {
    private var id : Int?
    private var date : String?
    private var productNameEn : String?
    private var productNameAr : String?
    private var productSerial : String?
    private var productSecret : String?
    private var productUserName : String?
    private var productSerialTitleEn : String?
    private var productSerialTitleAr : String?
    private var productSecretTitleEn : String?
    private var productSecretTitleAr : String?
    private var productUserNameTitleEn : String?
    private var productUserNameTitleAr : String?
    private var currencyAr : String?
    private var currencyEn : String?
    private var subReselleraccount : String?
    private var productDetailsAr : String?
    private var productDetailsEn : String?
    private var channelCode : String?
    private var total : Double?
    private var vatAmount : Double?
    private var price : Double?
    private var balanceAfter : Double?
    private var recommendedRetailPrice : Double?
    private var recommendedRetailPriceAfterVAT : String?
    private var expectedProfit : String?
    private var channelId : Int?
    var printCounter : Int?
    var cancelled : Bool = false
    var printed : Bool = false
    private var showPin : Bool? = false
    private var transactionID : String?
    var productType : String?

    var Currency: String{
        if lang == "ar"{
            return currencyAr ?? ""
        }else{
            return currencyEn ?? ""
        }
    }
    
    var ProductName: String{
        if lang == "ar"{
            return productNameAr ?? ""
        }else{
            return productNameEn ?? ""
        }
    }
    
    var ProductSerialTitle: String{
        if lang == "ar"{
            return productSerialTitleAr ?? ""
        }else{
            return productSerialTitleEn ?? ""
        }
    }
    
    
    var ProductSecretTitle: String{
        if lang == "ar"{
            return productSecretTitleAr ?? ""
        }else{
            return productSecretTitleEn ?? ""
        }
    }
    
    var ProductUserNameTitle: String{
        if lang == "ar"{
            return productUserNameTitleAr ?? ""
        }else{
            return productUserNameTitleEn ?? ""
        }
    }
    var ProductType: String{
        return productType ?? ""
    }
    var ProductSerial: String{
        return productSerial ?? ""
    }
    
    var ProductSecret: String{
        return productSecret ?? ""
    }
    var TransactionId: String{
        return transactionID ?? ""
    }
    
    var ProductUserName: String{
        return productUserName ?? ""
    }
    
    var ProductDetails: String{
        if lang == "ar"{
            return productDetailsAr ?? ""
        }else{
            return productDetailsEn ?? ""
        }
    }
    var ChannelCode: String{
        return channelCode ?? ""
    }
    var SubReselleraccount: String{
        return subReselleraccount ?? ""
    }
    var TransactionDate: String{
        if date !=  nil{
            return date!.replacingOccurrences(of:",", with: " ")
        }
        return ""
    }
    var Total: Double{
        return total ?? 0.0
    }
    var Price: Double{
        return price ?? 0.0
    }
    var VatAmount: Double{
        return vatAmount ?? 0.0
    }
    var Balance: Double{
        return balanceAfter ?? 0.0
    }
    
    var RecommendedRetailPrice: Double {
        return recommendedRetailPrice ?? 0.0
    }
    
    var RecommendedRetailPriceAfterVAT: String {
        return recommendedRetailPriceAfterVAT ?? "0.0"
    }
    
    var ExpectedProfit: String {
        return expectedProfit ?? "0.0"
    }
}
