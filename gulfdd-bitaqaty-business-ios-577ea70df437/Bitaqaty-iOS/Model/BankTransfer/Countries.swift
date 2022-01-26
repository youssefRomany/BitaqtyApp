//
//  Countries.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/2/21.
//

import Foundation
struct Countries: Codable {
    var errors: [ErrorMessage]? = []
    var selectedId: Int? = 0
    var lookupList: [Country]? = nil
}

struct Country: Codable {
    var id: Int
    var nameAr: String?
    var nameEn: String?
    
    func getCurrentName()-> String{
        if (lang == "en"){
            return nameEn ?? nameAr ?? ""
        }else{
            return nameAr ?? nameEn ?? ""
        }
    }
}
