//
//  User.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation

struct User: Codable {
    var errors: [ErrorMessage]? = nil
    var token: String? = nil
    var reseller: UserInfo? = nil
    var accountType: String? = nil
    var authenticationType: String? = nil
}
