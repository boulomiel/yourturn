//
//  DateStoreTests.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import Testing
import Foundation
@testable import YourTurn

@Suite("Date Store test", .serialized)
struct DateStoreTests {
    
    
    @Test("Test get dates for next day", .serialized, arguments: [Date.now], [Date.nowPlusOneDay])
    func testGetDates(from date: Date, to dateTo: Date) {
        let dateStore = DateStore()
        let dates = dateStore.getDates(from: date, to: dateTo, by: .day, value: 1)
        #expect(dates.count == 1)
    }
    
    @Test("Test get dates for three hours", .serialized, arguments: [Date.now], [Date.nowPlusThreeHours])
    func testGetDatesForThreeHours(from date: Date, to dateTo: Date) {
        let dateStore = DateStore()
        let dates = dateStore.getDates(from: date, to: dateTo, by: .hour, value: 1)
        #expect(dates.count == 3)
    }
    
    @Test("Test get all dates for specific month in year for 30 days month", .serialized, arguments: [4,6,9], [2020, 2021, 2022])
    func testGelAllMonthDateFrom30Days(day: Int, year: Int) {
        let dateStore = DateStore()
        let dates = dateStore.getAllDates(for: day, year: year)
        #expect(dates.count == 30)
    }
    
    @Test("Test get all dates for specific month in year for 31 days month", .serialized, arguments: [1,3,8], [2020, 2021, 2022])
    func testGelAllMonthDateFrom31Days(day: Int, year: Int) {
        let dateStore = DateStore()
        let dates = dateStore.getAllDates(for: day, year: year)
        #expect(dates.count == 31)
    }
    
}


extension Date {
    
    static let oneDay: TimeInterval = 24 * 60 * 60
    static let oneHour: TimeInterval = 60 * 60
    static let threeHours: TimeInterval = 60 * 60 * 3

    
    static var nowPlusOneDay : Date {
        return Date().advanced(by: Date.oneDay)
    }
    
    static var nowPlusOneHour : Date {
        return Date().advanced(by: Date.oneHour)
    }
    
    static var nowPlusThreeHours : Date {
        return Date().advanced(by: Date.threeHours)
    }
}
