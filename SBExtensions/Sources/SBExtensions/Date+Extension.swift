//
//  Date+Extension.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import Foundation

public typealias WeekDay = Date.WeekDay

public extension Date {
    
    var hoursAndMinutesPeriod: String {
        let formatter = DateComponentsFormatter()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: components) ?? hoursAndMinutesFormatted
    }
    
    var hoursAndMinutesFormatted: String {
        self.formatted(date: .omitted, time: .shortened)
    }
}

public extension Date {
    
    /// Returns the month number of the year '11'
    var monthNumber: Int {
        Calendar.current.component(.month, from: self)
    }
    
    /// Returns the day number of the month '26'
    var dayNumber: Int {
        Calendar.current.component(.day, from: self)
    }
    
    /// Returns the first letters of a weekday name 'SUN'
    var weekDay: String {
        string(with: "EEE")
    }
    
    /// Returns the first letters of the month 'JUL'
    var month: String {
        string(with: "MMM")
    }
    
    /// Returns a 4 characters digits String of the date's year as such '2020'
    var year: String {
        string(with: "YYYY")
    }
    
    /// Returns the first letters of the month 'JULY'
    var fullMonth: String {
        string(with: "MMMM")
    }
    
    
    /// Create a string from the date
    /// - Parameter format: The format to be applied [Help with format](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW13)
    /// - Returns: String of the formatted date
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    /// Gets the week of a given date
    /// - Returns: An array of Date.WeekDay sorted.
    func fetchWeek() -> [WeekDay] {
        guard let weekForDate = Calendar.current.dateInterval(of: .weekOfMonth, for: self) else {
            return []
        }
        
        let startOfWeek = weekForDate.start
        return (0..<7).compactMap { index -> WeekDay? in
            if let day =  Calendar.current.date(byAdding: .day, value: index, to: startOfWeek) {
                return .init(date: day)
            }
            return nil
        }
    }
    
    
    /// Creates the next week base on the last day of the previous week
    /// - Returns: An array of Date.WeekDay sorted.
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextFirstWeekDay = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return nextFirstWeekDay.fetchWeek()
    }
    
    /// Creates the previous week base on the last day of the previous week
    /// - Returns: An array of Date.WeekDay sorted.
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousLastDay = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        return previousLastDay.fetchWeek()
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func isToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    struct WeekDay: Identifiable, Hashable {
        public let id: UUID = .init()
        public let date: Date
    }
}
