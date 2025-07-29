//
//  DatesFetcher.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import SBExtensions
import Playgrounds
import Foundation
import OSLog

public protocol DateStoreProtocol {
    func getDates(from first: Date, to second: Date, by adding: Calendar.Component, value: Int) -> [Date]
    func getAllDates(for month: Int, year: Int) -> [Date]
}

public struct DateStore: DateStoreProtocol {
    
    let calendar: Calendar
    
    private let logger: Logger
    
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.logger = Logger(subsystem: "com.shiftbee.moondev", category: "DateStore")
    }
    
    /// Gets numbers from a specific date to another specific date, by adding a wanted componenent (day, hours, min ... )
    /// - Parameters:
    ///   - first: startDate
    ///   - second: destionation Date
    ///   - adding: Calendar.Component bump
    ///   - value: number of bumps at onces
    /// - Returns: arrays of dates
    public func getDates(from first: Date, to second: Date, by adding: Calendar.Component, value: Int) -> [Date] {
        guard second > first else { return [] }
        var results: [Date] = []
        let roundedSecond = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: second))!
        var copy = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: first))!
        print(roundedSecond.formatted(), "-" ,copy.formatted())
        while copy < roundedSecond, let date = calendar.date(byAdding: adding, value: value, to: copy) {
            copy = date
            results.append(date)
        }
        return results
    }
    
    public func getAllDates(for month: Int, year: Int) -> [Date] {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            var dateComponents = components
            dateComponents.day = day
            return calendar.date(from: dateComponents)
        }
    }
    
    
    /// Returns the week in week day that includes the base date
    /// - Parameter from: The date we want to find the week which contains it
    /// - Returns: An array of week day from sunday to saturday including the base date
    public func getWeek(from base:  Date) -> [Date] {
        
        // Makes the date clean
        guard let midDayDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: base) else {
            return []
        }
        var weekDays: [Date] = [midDayDate]
        
        var day = Calendar.current.component(.weekday, from: midDayDate)
        
        while day > 1 {
            if let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: weekDays.last!) {
                weekDays.append(previousDate)
            }
            day -= 1
        }
        
        day = Calendar.current.component(.weekday, from: midDayDate)
        while day < 7 {
            if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: weekDays.last!) {
                weekDays.append(nextDay)
            }
            day += 1
        }
        
        guard let weekForDate = Calendar.current.dateInterval(of: .weekOfMonth, for: base) else {
            return []
        }
        
        let startOfWeek = weekForDate.start
        
        (0..<7).forEach { index in
            if let day =  Calendar.current.date(byAdding: .day, value: index, to: startOfWeek) {
                weekDays.append(day)
            }
        }
        
        return weekDays.sorted(by: { $0 < $1 })
    }
    
    
    ///  Gets the week after the last day of the current week based on the input
    /// - Parameter base: input date
    /// - Returns: [Date]
    public func nextWeek(from base: Date) -> [Date] {
        let currentWeek = getWeek(from: base)
        guard let lastDay = currentWeek.last else {
            logger.error("week is empty for date \(base)")
            return []
        }
        guard let nextFirstWeekDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDay) else {
            logger.error("Could not get next day from \(lastDay)")
            return []
        }
        
        return getWeek(from: nextFirstWeekDay)
    }
    
    ///  Gets the week before the first day of the current week based on the input
    /// - Parameter base: input date
    /// - Returns: [Date]
    public func previousWeek(from base: Date) -> [Date] {
        let currentWeek = getWeek(from: base)
        guard let firstDay = currentWeek.first else {
            logger.error("week is empty for date \(base)")
            return []
        }
        
        guard let nextFirstWeekDay = Calendar.current.date(byAdding: .day, value: -7, to: firstDay) else {
            logger.error("Could not get next day from \(firstDay)")
            return []
        }
        
        return getWeek(from: nextFirstWeekDay)
    }
}
