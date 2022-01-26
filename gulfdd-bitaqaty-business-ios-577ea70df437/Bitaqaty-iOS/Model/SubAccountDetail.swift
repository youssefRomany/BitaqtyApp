//
//  SubAccountDetail.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
class SubAccountDetail: Codable, Copying  {
    typealias Prototype = SubAccountDetail // <-- requires adding this line to classes

    required init(instance: SubAccountDetail) {
        
    }
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Prototype(instance: self)
    }
    private var purchaselimit: Double?
    var purchaseTotal: Double?
    var description: String?
    private var subResellerType: String?
    private var subResellerTypeDuration: String?
    var otpEnabled: Bool?
    private var currentRemainingLimit: Double?
    
    var SubResellerType: String{
        set{
            subResellerType = newValue
        }
        get{
            return subResellerType ?? ""
        }
    }
    
    var SubResellerTypeDuration: String{
        set{
            subResellerTypeDuration = newValue
        }
        get{
            return subResellerTypeDuration ?? ""
        }
    }
    var Purchaselimit: Double{
        set{
            purchaselimit = newValue
        }
        get{
            return purchaselimit ?? 0.0
        }
    }
    var CurrentRemainingLimit: Double{
        set{
            currentRemainingLimit = newValue
        }
        get{
            return currentRemainingLimit ?? 0.0
        }
    }
    var PurshaseTotal: Double{
        set{
            purchaseTotal = newValue
        }
        get{
            return purchaseTotal ?? 0.0
        }
    }
    
}
