//
//  Double+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation

extension Double{
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en")
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
