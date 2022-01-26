

import Foundation
struct RechargeMethod : Codable {
	private var id : Int?
	let nameAr : String?
	let nameEn : String?
	let chargingCode : String?
	private var discriminatorValuel : String?
	let bitaqatyBusinessPermission : Permissions?
    var displayOrder: Int? = 0

    var ChargingCode: String{
        return chargingCode ?? ""
    }
    var Name: String{
        return lang == "en" ? nameEn ?? "" : nameAr ?? ""
    }
    var Id: Int{
        return id ?? 0
    }
    var DiscriminatorValue: String{
        return discriminatorValuel ?? ""
    }
    
    func getDisplayOrder() -> Int{
        return displayOrder ?? 0
    }
}
