//
//  DatesFetcher.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import Foundation

public protocol DateStoreProtocol {
    func getDates(from first: Date, to second: Date, by adding: Calendar.Component, value: Int) -> [Date]
    func getAllDates(for month: Int, year: Int) -> [Date]
}

public struct DateStore: DateStoreProtocol {
    
    let calendar: Calendar
    
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
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
}
