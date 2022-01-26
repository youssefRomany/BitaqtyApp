//
//  Ticket.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/17/21.
//

import Foundation

struct Ticket: Codable{
    var id: Int
    var nameEn: String
    var nameAr: String
    
    func getName() -> String{
        if (lang == "en"){
            return nameEn
        }else{
            return nameAr
        }
    }
}

struct TicketRequestBody: Codable{
    var name: String
    var mobileNumber: String
    var email: String? = nil
    var ticketTypeDTO: Ticket? = nil
    var details: String? = nil
}
