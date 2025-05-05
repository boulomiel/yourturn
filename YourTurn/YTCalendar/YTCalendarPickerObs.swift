//
//  YTCalendarPickerObs.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import Foundation
import SwiftUI

@Observable
class YTCalendarPickerObs {
    
    let dateStore: DateStore = .init()
    var startMonthDate: Date = .now
    var weeks: [[Date]] = []
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL" // Full month name
        let monthName = dateFormatter.string(from: startMonthDate)
        return monthName
    }
    
    init() {
        buildMonthCalendar()
    }
    
    func getCurrentMonthDate() {
        let current: Date = .now
        let components = Calendar.current.dateComponents([.year, .month], from: current)
        guard let year = components.year, let month = components.month else {
            return
        }
        let datesCurrentMonths = dateStore.getAllDates(for: month, year: year)
        // Create a 2D array of weeks
        var weeks: [[Date]] = []
        
        for i in stride(from: 0, to: datesCurrentMonths.count, by: 7) {
            let week = Array(datesCurrentMonths[i..<min(i + 7, datesCurrentMonths.count)])
            weeks.append(week)
        }
        
        // Now `weeks` contains arrays of up to 7 dates each (a week)
        for (weekIndex, week) in weeks.enumerated() {
            print("Week \(weekIndex + 1):")
            for date in week {
                print(date.formatted(date: .complete, time: .omitted))
            }
        }
    }
    
    func buildMonthCalendar() {
        let calendar = Calendar.current
        let current: Date = .now
        
        // Set calendar to start the week on Sunday
        var calendarWithSundayStart = calendar
        calendarWithSundayStart.firstWeekday = 1 // Sunday = 1
        
        let components = calendarWithSundayStart.dateComponents([.year, .month], from: current)
        guard let year = components.year, let month = components.month,
              let monthStart = calendarWithSundayStart.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendarWithSundayStart.range(of: .day, in: .month, for: monthStart)
        else { return }
        
        startMonthDate = monthStart
        
        // Get all dates in the month
        let allDatesInMonth: [Date] = range.compactMap { day in
            calendarWithSundayStart.date(from: DateComponents(year: year, month: month, day: day))
        }
        
        // Pad beginning of first week with previous month's days if needed
        let firstDate = allDatesInMonth.first!
        let weekdayOfFirst = calendarWithSundayStart.component(.weekday, from: firstDate)
        let paddingBefore = (weekdayOfFirst - calendarWithSundayStart.firstWeekday + 7) % 7
        
        var paddedDates: [Date] = []
        
        // Add dates before the first day of month
        if paddingBefore > 0 {
            for i in (1...paddingBefore).reversed() {
                if let previousDate = calendarWithSundayStart.date(byAdding: .day, value: -i, to: firstDate) {
                    paddedDates.append(previousDate)
                }
            }
        }
        
        paddedDates += allDatesInMonth
        
        // Pad end of last week with next month's days if needed
        let lastDate = allDatesInMonth.last!
        let weekdayOfLast = calendarWithSundayStart.component(.weekday, from: lastDate)
        let paddingAfter = (7 - ((weekdayOfLast - calendarWithSundayStart.firstWeekday + 7) % 7 + 1)) % 7
        
        if paddingAfter > 0 {
            for i in 1...paddingAfter {
                if let nextDate = calendarWithSundayStart.date(byAdding: .day, value: i, to: lastDate) {
                    paddedDates.append(nextDate)
                }
            }
        }
        
        // Split into weeks
        var weeks: [[Date]] = []
        for i in stride(from: 0, to: paddedDates.count, by: 7) {
            let week = Array(paddedDates[i..<i+7])
            weeks.append(week)
        }
        
        self.weeks = weeks
        
        //       //  Example: Print weeks
        //        for (i, week) in weeks.enumerated() {
        //            print("Week \(i + 1):")
        //            for date in week {
        //                print("  \(calendarWithSundayStart.component(.day, from: date))")
        //            }
        //        }
        
    }
}
