//
//  Date+Extension.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 12/10/2021.
//

import Foundation
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        //        let calendar = Calendar(identifier: .gregorian)
        //        let components = calendar.dateComponents([.year, .month], from: self)
        //        return  calendar.date(from: components)!
        //
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return (interval?.start.toLocalTime())! // Without toLocalTime it give last months last date
        
    }
    func toLocalTime() -> Date {
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!.toLocalTime()
    }
    var startOfLastMonth: Date {
        var components = DateComponents()
        components.month = -1
        components.day = 0
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!.startOfDay//.toLocalTime()
    }
    var startOfThisMonth: Date {
        var components = DateComponents()
        components.month = 0
        components.day = 0
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!.startOfDay//.toLocalTime()
    }
    var endOfLastMonth: Date {
        var components = DateComponents()
        components.month = 0
        components.day = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
            .setTime(bySettingHour: 23, minute: 59)
    }
    
    var last7Day: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!.toLocalTime()
    }
    
    var getYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!.setTime(bySettingHour: 23, minute: 59)
    }
    
    
//
//    func startOfThisMonth() -> Date {
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!.toLocalTime()
//    }
//
    func endOfThisMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!.toLocalTime()
    }
    //
    //    var getLast30Day: Date {
    //        return Calendar.current.date(byAdding: .day, value: -30, to: self)!
    //    }
    //
    //    func isMonday() -> Bool {
    //        let calendar = Calendar(identifier: .gregorian)
    //        let components = calendar.dateComponents([.weekday], from: self)
    //        return components.weekday == 2
    //    }
    //
    //        func getLast6Month() -> Date? {
    //            return Calendar.current.date(byAdding: .month, value: -6, to: self)
    //        }
    //
    //        func getLast3Month() -> Date? {
    //            return Calendar.current.date(byAdding: .month, value: -3, to: self)
    //        }
    //
    //
    //
    //
    //
    //
    //        func getPreviousMonth() -> Date? {
    //           // return Calendar.current.date(byAdding: .month, value: -1, to: self)
    //            return Calendar.current.date(byAdding: .month, value: -1, to: Date())
    //        }
    //
    //
    //        func getThisMonthEnd() -> Date? {
    //            let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
    //            components.month += 1
    //            components.day = 1
    //            components.day -= 1
    //            return Calendar.current.date(from: components as DateComponents)!
    //        }
    //
    //        //Last Month Start
    //        func getLastMonthStart() -> Date? {
    //            let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
    //            components.month -= 1
    //            return Calendar.current.date(from: components as DateComponents)!
    //        }
    //
    //        //Last Month End
    //        func getLastMonthEnd() -> Date? {
    //            let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
    //            components.day = 1
    //            components.day -= 1
    //            return Calendar.current.date(from: components as DateComponents)!
    //        }
    //    //
    
    func setTime(bySettingHour hour: Int, minute: Int) -> Date{
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self)!
    }
}
