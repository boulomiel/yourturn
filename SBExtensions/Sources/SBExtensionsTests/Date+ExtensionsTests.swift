//
//  Date+ExtensionsTests.swift
//  SBExtensions
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import Testing
import Foundation
import SBExtensions

@Suite("Testing date+extensions")
struct DateExtensionTests {
    let fixedDate = Date(timeIntervalSince1970: 1754084700) // August 02, 2025, 15:45:00 GMT

    @Test("string(with:)")
    func testStringWith() throws {
        print(fixedDate)
        #expect(fixedDate.string(with: "yyyy") == "2025")
        #expect(fixedDate.string(with: "MM") == "08" )
        #expect(fixedDate.string(with: "dd") == "02")
        #expect(fixedDate.string(with: "EEE") == "Sat")
        #expect(fixedDate.string(with: "MMM") == "Aug")
    }

    @Test("fetchWeek()")
    func testFetchWeek() throws {
        let week = fixedDate.fetchWeek()
        //#require(week.count == 7)
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: fixedDate)!.start
        #expect(week.first?.date == startOfWeek)
    }

    @Test("createNextWeek()")
    func testCreateNextWeek() throws {
        let currentWeek = fixedDate.fetchWeek()
        let nextWeek = fixedDate.createNextWeek()
        //#require(nextWeek.count == 7)
        #expect(nextWeek.first?.date == Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeek.first!.date))
    }

    @Test("createPreviousWeek()")
    func testCreatePreviousWeek() throws {
        let currentWeek = fixedDate.fetchWeek()
        let previousWeek = currentWeek.first?.date.createPreviousWeek() ?? []
      //  #require(previousWeek.count == 7)
        #expect(previousWeek.first?.date == Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeek.first!.date))
    }

    @Test("isToday()")
    func testIsToday() {
        #expect(Date.now.isToday() == true)
        let distantDate = Date.distantPast
        #expect(distantDate.isToday() == false)
    }

    @Test("isSameDay(as:)")
    func testIsSameDayAs() {
        let sameDay = fixedDate
        let differentDay = fixedDate.addingTimeInterval(86400) // Next day
        #expect(fixedDate.isSameDay(as: sameDay) == true)
        #expect(fixedDate.isSameDay(as: differentDay) == false)
    }
}
