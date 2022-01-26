//
//  DataResult.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/12/21.
//

import Foundation
struct DataResult: Codable {
    var errors: [ErrorMessage]? = nil
    var loginProcessToken: String? = nil
}
