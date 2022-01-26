//
//  Copying+Extension.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/10/21.
//

import Foundation
protocol Copying {
    init(instance: Self)
}

extension Copying{
    func copy() -> Self{
        return Self.init(instance: self)
    }
}
