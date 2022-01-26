//
//  Data+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation

extension Data {
    
    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
    
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x50 : "application/ms",
        0x46 : "text/plain",
    ]
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
    var extensionStr : String{
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        if Data.mimeTypeSignatures[c] != nil{
            return "\(Data.mimeTypeSignatures[c]?.split(separator: "/").last ?? "")"
        }else{
            return ""
        }
    }
}

extension Collection{
    var isNotEmpty: Bool{
        return !self.isEmpty
    }
}
