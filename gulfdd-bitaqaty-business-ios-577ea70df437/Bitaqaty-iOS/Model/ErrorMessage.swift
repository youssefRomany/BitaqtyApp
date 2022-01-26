//
//  ErrorMessage.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation

struct ErrorMessage: Codable {
    var errorCode: String
    var errorMessage: String
    
    init(_ msg: String,_ code: String) {
        self.errorMessage = msg
        self.errorCode = code
    }
    
    init(_ msg: String) {
        self.errorMessage = msg
        self.errorCode = "-1"
    }
}
