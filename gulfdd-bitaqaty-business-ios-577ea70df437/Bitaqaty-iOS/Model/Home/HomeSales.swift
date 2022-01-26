//
//  HomeSales.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 11/10/2021.
//

import Foundation
struct HomeSales : Codable {
    //DailySales
    var thisMonthAvg : String?
    var lastMonthAvg : String?
    var salesIncrease : String?
    var todaySales : Sales?
    var weeklySalesDTO : [Sales]?
    
    
    //DailyRecharge
    var remainingBalance : String?
    var lastWeekAvg : String?
    var todayRecharge : Sales?
    var weeklyDataDTO : [Sales]?
    var remaingBalanceSetting : Int?

    var LastWeekAvg: Double{
        if lastWeekAvg != nil && lastWeekAvg != "N/A"{
            return (lastWeekAvg! as NSString).doubleValue
        }
        return 0.0
    }
}
