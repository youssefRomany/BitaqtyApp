//
//  DateUtils.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation

class DateUtils {
    static let ds = DateUtils();
    func getDateWithTime(date: String)->String{
        if(date.isEmpty){
            return ""
        }
        var dateFormatted = "";
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        var day = dateFormatter.date(from: date);
        if(day == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
            dateFormatter.timeZone = TimeZone(identifier: "UTC")!
            day = dateFormatter.date(from: date);
        }
        if(day == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            day = dateFormatter.date(from: date);
        }
        
        if(day != nil){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: lang)
            dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
            dateFormatted = dateFormatter.string(from: day!);
        }
        return dateFormatted;
    }
    
    func geDate(date: String)->String{
        if(date.isEmpty){
            return ""
        }
        var dateFormatted = "";
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        var day = dateFormatter.date(from: date);
        if(day == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
            dateFormatter.timeZone = TimeZone(identifier: "UTC")!
            day = dateFormatter.date(from: date);
        }
        if(day == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            dateFormatter.timeZone = TimeZone(identifier: "UTC")!
            day = dateFormatter.date(from: date);
        }
        
        if(day != nil){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: lang)
            dateFormatter.dateFormat = "EEE, dd MMM yyyy"
            dateFormatted = dateFormatter.string(from: day!);
        }
        return dateFormatted;
    }
    
    func getTimeFromDate(_ min: Int) -> String{
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: min, to: Date())!;
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa";
        dateFormatter.locale = Locale(identifier: lang)
        return dateFormatter.string(from: date);
    }
    func getTodayDate()->String{
        let date = Date();
        var dateFormatted = "";
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "MMMM yyyy";
        dateFormatted = dateFormatter.string(from: date);
        print("dateFormatted \(dateFormatted)")
        return dateFormatted;
    }
    
    func getTodayYear()->String{
        let date = Date();
        var dateFormatted = "";
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "yyyy";
        dateFormatted = dateFormatter.string(from: date);
        print("dateFormatted \(dateFormatted)")
        return dateFormatted;
    }
    
    func getTodayMonth()->String{
        let date = Date();
        var dateFormatted = "";
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "MMM";
        dateFormatted = dateFormatter.string(from: date);
        print("dateFormatted \(dateFormatted)")
        return dateFormatted;
    }
    func getDateFormatted(date: String)->String{
        if(date.isEmpty){
            return ""
        }
        var dateFormatted = "";
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        var day = dateFormatter.date(from: date);
        if(day == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
            dateFormatter.timeZone = TimeZone(identifier: "UTC")!
            day = dateFormatter.date(from: date);
        }
        if(day == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            dateFormatter.timeZone = TimeZone(identifier: "UTC")!
            day = dateFormatter.date(from: date);
        }
        
        if(day != nil){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: lang)
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatted = dateFormatter.string(from: day!);
        }
        return dateFormatted;
    }
    
    func lastVisitDate(_ timeInterval: Double) -> String{
        let date = Date(timeIntervalSince1970: (timeInterval / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd-MM-yyyy, hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
    func getDateFromString(_ dateStr: String?)-> Date{
        var date: Date? = nil
        let dateFormatter = DateFormatter()
        guard let dateStr = dateStr else {
            return Date()
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        date = dateFormatter.date(from: dateStr)
        if (date == nil){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            date = dateFormatter.date(from: dateStr)
        }
        if (date == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: dateStr)
        }
        return date ?? Date()
    }
    
    static func getStrFromDate(_ date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getLocalizeStrFromDate(_ date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func getLocalizeTransferDate(_ date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func getTransferDate(_ date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func getChartDay(dateStr: String)-> String {
        var date: Date? = nil

         if (dateStr.isEmpty){
             return dateStr
         }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: dateStr)
        if date != nil{
            dateFormatter.locale = Locale(identifier: lang)
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date!)
        }
        return dateStr
     }
    
    static func getHomeBankDate(_ dateStr: String)-> String{
        if dateStr.isEmpty{
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        return dateFormatter.string(from: date!)
    }
    
    static func getLogDate(_ dateStr: String)-> String{
        if dateStr.isEmpty{
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        if date != nil{
            return dateFormatter.string(from: date!)
        }else{
            return dateStr
        }
    }
}
