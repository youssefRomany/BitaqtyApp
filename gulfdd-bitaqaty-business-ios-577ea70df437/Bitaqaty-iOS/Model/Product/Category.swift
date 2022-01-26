//
//  Category.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import Foundation
struct Category: Codable {
    var id: Int = 0
    private var nameAr: String? = nil
    private  var nameEn: String? = nil
    private  var imagePath: String? = nil
    var descriptionAr: String? = nil
    var descriptionEn: String? = nil
    private  var logoPath: String? = nil
    
    
    init(){
        
    }
    
    init(_ topMerchant: TopMerchant){
        self.id = topMerchant.merchantId ?? 0
        self.nameAr = topMerchant.nameAr
        self.nameEn = topMerchant.nameEn
        self.logoPath = topMerchant.logoPath
        self.descriptionAr = topMerchant.descriptionAr
        self.descriptionEn = topMerchant.descriptionEn
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
    
    var ImagePath: String{
        return imagePath ?? ""
    }
    
    var LogoPath: String{
        return logoPath ?? ""
    }
    
}
