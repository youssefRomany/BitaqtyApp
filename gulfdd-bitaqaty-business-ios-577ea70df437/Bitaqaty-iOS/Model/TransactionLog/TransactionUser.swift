//
//  TransactionUser.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/21/21.
//

import Foundation
struct TransactionUser: Codable {
    
    private var id: Int? = 0
    var fullName: String? = nil
    private var userName: String? = nil
    
    var UserName: String{
        return userName ?? ""
    }
    var Id: Int{
        return id ?? 0
    }
    
    init(){
        
    }
    
    init(_ id: Int?,_ fullName: String?,_ userName: String?){
        self.id = id
        self.fullName = fullName
        self.userName = userName
    }
}
