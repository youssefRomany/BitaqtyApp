//
//  HomeSubAccount.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 11/10/2021.
//

import Foundation
struct HomeSubAccount : Codable {
    private var subAccountName : String?
    private var subAccountType : String?
    private var sales : String?
    
    var Name: String{
        return subAccountName ?? ""
    }
    
    var AccountType: String{
        return subAccountType ?? ""
    }
    var Sales: String{
        return sales ?? ""
    }
}
