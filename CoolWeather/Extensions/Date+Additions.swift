//
//  Date+Additions.swift
//  Swift+Extensions
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//
//  https://stackoverflow.com/questions/8119880/how-to-add-one-month-to-an-nsdate
//

import Foundation

extension Date {
    
    var second:Int { return Calendar.current.component(.second, from:self) }
    var minute:Int { return Calendar.current.component(.minute, from:self) }
    var hour:Int { return Calendar.current.component(.hour, from:self) }
    var day:Int { return Calendar.current.component(.day, from:self) }
    var month:Int { return Calendar.current.component(.month, from:self) }
    var year:Int { return Calendar.current.component(.year, from:self) }
    
    func addYear(n: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: n, to: self)!
    }
    
    func addMonth(n: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: n, to: self)!
    }
    
    func addDay(n: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: n, to: self)!
    }
    
    func addHour(n: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: n, to: self)!
    }
    
    func addSec(n: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: n, to: self)!
    }
}

extension Date {
    // https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
    
    static func -(lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

extension Date {
    static func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = Int(interval)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}

extension Date {
    
    func zeroDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func zeroNextDay() -> Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}

extension Date {
    // https://stackoverflow.com/questions/29392874/converting-utc-date-format-to-local-nsdate/29393084#29393084
    
    // Convert local time to UTC (or GMT)
    func toUTC() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Date {
    
    func unixTime() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    static func fromUnixTime(timestamp: Int) -> Date {
        return Date.init(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
