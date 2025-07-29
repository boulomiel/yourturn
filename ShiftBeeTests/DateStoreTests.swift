//
//  DateStoreTests.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 04/05/2025.
//

import Testing
import Foundation
@testable import ShiftBee

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

    @Test("Test getWeek returns 7 dates")
    func testGetWeek() {
        let dateStore = DateStore()
        let week = dateStore.getWeek(from: Date.now)
        #expect(week.count == 7)
    }

    @Test("Test nextWeek returns the week after the given week")
    func testNextWeek() {
        let dateStore = DateStore()
        let currentWeek = dateStore.getWeek(from: Date.now)
        let nextWeek = dateStore.nextWeek(from: currentWeek.last!)
        #expect(nextWeek.count == 7)
        #expect(nextWeek.first! > currentWeek.last!)
    }

    @Test("Test previousWeek returns the week before the given week")
    func testPreviousWeek() {
        let dateStore = DateStore()
        let currentWeek = dateStore.getWeek(from: Date.now)
        let previousWeek = dateStore.previousWeek(from: currentWeek.first!)
        #expect(previousWeek.count == 7)
        #expect(previousWeek.last! < currentWeek.first!)
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

@Suite("Date Extension Tests", .serialized)
struct DateExtensionTests {

    @Test("nowPlusOneDay returns about one day ahead")
    func testNowPlusOneDay() {
        let now = Date()
        let plusOneDay = Date.nowPlusOneDay
        let diff = plusOneDay.timeIntervalSince(now)
        #expect(abs(diff - Date.oneDay) < 1)
    }

    @Test("nowPlusOneHour returns about one hour ahead")
    func testNowPlusOneHour() {
        let now = Date()
        let plusOneHour = Date.nowPlusOneHour
        let diff = plusOneHour.timeIntervalSince(now)
        #expect(abs(diff - Date.oneHour) < 1)
    }

    @Test("nowPlusThreeHours returns about three hours ahead")
    func testNowPlusThreeHours() {
        let now = Date()
        let plusThreeHours = Date.nowPlusThreeHours
        let diff = plusThreeHours.timeIntervalSince(now)
        #expect(abs(diff - Date.threeHours) < 1)
    }

    @Test("oneDay constant equals 86400 seconds")
    func testOneDayConstant() {
        #expect(Date.oneDay == 24 * 60 * 60)
    }

    @Test("oneHour constant equals 3600 seconds")
    func testOneHourConstant() {
        #expect(Date.oneHour == 60 * 60)
    }

    @Test("threeHours constant equals 10800 seconds")
    func testThreeHoursConstant() {
        #expect(Date.threeHours == 3 * 60 * 60)
    }
}
