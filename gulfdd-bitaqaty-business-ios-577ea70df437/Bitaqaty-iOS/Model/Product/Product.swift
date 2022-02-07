//
//  Product.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import Foundation
struct Product: Codable {
    var id : Int?
    private var nameAr : String?
    var nameEn : String?
    var descriptionAr : String?
    var descriptionEn : String?
    private var availableStockAmount : Int?
    private var price : String?
    var fullPrice : String?
    private var vat : String?
    var fullVat : String?
    private var priceAfterVat : String?
    var fullPriceAfterVat : String?
    var vatePercentage : String?
    private var merchantNameAr : String?
    private var merchantNameEn : String?
    private var productSmallImagePath : String?
    var bulkMin : Int?
    var bulkMax : Int?
    var productType : String?
    var bulkPurchaseEnabled : Bool?
    var recommendedRetailPrice : String?
    var recommendedRetailPriceAfterVat : String?
    var expectedProfit : String?

    var name: String{
        if lang == "en"{
            return nameEn ?? ""
        }else{
            return nameAr ?? ""
        }
    }
    var merchantName: String{
        if lang == "en"{
            return merchantNameEn ?? ""
        }else{
            return merchantNameAr ?? ""
        }
    }
    var ImagePath: String{
        return productSmallImagePath ?? ""
    }
    var Price: String{
        return price ?? "0"
    }
    var Vat: String{
        return vat ?? "0"
    }
    var PriceAfterVat: String{
        return priceAfterVat ?? "0"
    }
    var AvailableInStock: Int{
        return availableStockAmount ?? 0
    }
    
    var priceDouble: Double{
        return Double(price ?? "0.0") ?? 0.0
    }
    
    var recRetailDouble: Double{
        return Double(recommendedRetailPrice ?? "0.0") ?? 0.0
    }
    var recAfterVatRetailDouble: Double{
        return Double(recommendedRetailPriceAfterVat ?? "0.0") ?? 0.0
    }
    var vatDouble: Double{
        return Double(vat ?? "0.0") ?? 0.0
    }
    
    var priceAfterVatDouble: Double{
        return Double(priceAfterVat ?? "0.0") ?? 0.0
    }
    
    var isInStock: Bool{
        return (AvailableInStock > 0 || productType == ProductType.Predefined.rawValue || productType == ProductType.Service.rawValue)
    }
}
