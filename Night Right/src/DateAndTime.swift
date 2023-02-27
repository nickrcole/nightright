//
//  DateAndTime.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/21/22.
//

import Foundation

// https://www.datetimeformatter.com/how-to-format-date-time-in-swift/

extension Date {
    var weekdaySymbol: String {
        return Calendar(identifier: .gregorian).weekdaySymbols[(self.dayNumberOfWeek() ?? 1) - 1]
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

extension Date {
    func isSameDay(asDate: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: asDate)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    var asDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    var asMonthDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: self)
    }
    
    var asFullDateStringForDirectory: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M:d:yy_HH:mm"
        return formatter.string(from: self)
    }
    
    var forAlarmComparison: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        return formatter.string(from: self)
    }
    
    var asTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: self)
    }
    
}

extension Date {
    var asHourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        return formatter.string(from: self)
    }
}

extension Date {
    var timeInMinutes: Int {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "mm"
        let hour = Int(hourFormatter.string(from: self))
        let minute = Int(minFormatter.string(from: self))
        return (60 * (hour ?? 0)) + (minute ?? 0)
    }

}

func createDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    return formatter.date(from: date) ?? Date()
}

func diffMinutes(start: Date, end: Date) -> Int {
    let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
    let hours = diffComponents.hour
    let minutes = diffComponents.minute
    return (((hours ?? 0) * 60) + (minutes ?? 0))
}
