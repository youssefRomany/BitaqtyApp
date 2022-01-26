//
//  TopMerchants.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/14/21.
//

import Foundation

struct TopMerchants: Codable{
    var errors: [ErrorMessage]? = nil
    var merchants: [TopMerchant]? = nil
    var defaultHomeMerchantLength: Int = 0
}

struct TopMerchant: Codable{
    var id: Int? = nil
    var nameAr: String? = nil
    var nameEn: String? = nil
    var logoPath: String? = nil
    var merchantId: Int? = nil
    var categoryId: Int? = nil
    var defaultHomeMerchant: Bool? = nil
    var displayOrder: Int? = nil
    var deleted: Bool? = nil
    var updated: Bool? = nil
    var category: Bool? = nil
    var descriptionAr: String? = nil
    var descriptionEn: String? = nil
    var howToUseAr: String? = nil
    var howToUseEn: String? = nil
    
    func currentId()-> Int{
        if (category == true){
            return categoryId ?? 0
        }else{
            return merchantId ?? 0
        }
    }
    
    func getName() -> String{
        if lang == "en"{
            return nameEn ?? nameAr ?? ""
        }else{
            return nameAr ?? nameEn ?? ""
        }
    }
}

struct TopChildMerchant : Codable {
    var errors: [ErrorMessage]? = nil
    var merchants: [Merchant]? = nil
    var totalElementsCount: Int = 0
}
