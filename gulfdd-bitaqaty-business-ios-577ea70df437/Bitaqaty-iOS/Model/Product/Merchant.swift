//
//  Merchant.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import Foundation
struct Merchant: Codable {
    
    var id: Int = 0
    private var nameAr: String? = nil
    private var nameEn: String? = nil
    var descriptionAr: String? =    nil
    var descriptionEn: String? = nil
    var howToUseAr: String? =    nil
    var howToUseEn: String? = nil
    var logoPath: String? = nil
    var pinned: Bool? = false
    
    init(){
        
    }
    
    init(_ customMerchant: TopMerchant){
        self.id = customMerchant.currentId()
        self.nameAr = customMerchant.nameAr
        self.nameEn = customMerchant.nameEn
        self.logoPath = customMerchant.logoPath
        self.descriptionAr = customMerchant.descriptionAr
        self.descriptionEn = customMerchant.descriptionEn
        self.howToUseAr = customMerchant.howToUseAr
        self.howToUseEn = customMerchant.howToUseEn
    }
    
    var name: String{
        if lang == "en"{
            return nameEn ?? ""
        }else{
            return nameAr ?? ""
        }
    }
    
    var description: String{
        if lang == "en"{
            return descriptionEn ?? ""
        }else{
            return descriptionAr ?? ""
        }
    }
    
    var howToUse: String?{
        if lang == "en"{
            return howToUseEn
        }else{
            return howToUseAr
        }
    }
    
}
