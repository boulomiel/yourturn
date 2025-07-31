//
//  WeekScrollCalendarObs.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import SBExtensions
import SwiftData
import SBHistory
import Foundation

@Observable
class WeeklyCalendarViewObs {
    
    var selectedWeekIndex: Int
    var currentWeeks: [[WeekDay]]
    var selectedDate: Int?
    let startDate: Date
    private var canCreateWeek: Bool = false
    
    var headerDate: Date {
        currentWeeks[selectedWeekIndex][selectedDate ?? 0].date
    }
    
    init(startDate: Date) {
        self.startDate = startDate.startOfDay
        let currentWeek = startDate.fetchWeek()
        let previousWeek = currentWeek[0].date.createPreviousWeek()
        let nextWeek = currentWeek[currentWeek.count-1].date.createNextWeek()
        self.currentWeeks = [previousWeek, currentWeek, nextWeek]
        self.selectedWeekIndex = 1
        self.selectedDate = currentWeeks[selectedWeekIndex].firstIndex(where: { $0.date.dayNumber == Date().dayNumber })
    }
    
    func paginateWeek() {
        guard currentWeeks.indices.contains(selectedWeekIndex) else {
            return
        }
        
        if let firstDay = currentWeeks[selectedWeekIndex].first?.date, selectedWeekIndex == 0 {
            currentWeeks.insert(firstDay.createPreviousWeek(), at: 0)
            currentWeeks.removeLast()
            selectedWeekIndex = 1
        }
        
        if let lastDay = currentWeeks[selectedWeekIndex].last?.date, selectedWeekIndex == currentWeeks.count - 1 {
            currentWeeks.append(lastDay.createNextWeek())
            currentWeeks.removeFirst()
            selectedWeekIndex = currentWeeks.count - 2
        }
        
        canCreateWeek = false
    }
    
    func onSelectedWeekIndexChange(_ oldIndex: Int?, newIndex: Int?) {
        if newIndex == 0 || newIndex == currentWeeks.count-1 {
            canCreateWeek = true
        }
    }
    
    func onSwipe(_ oldValue: Bool, newValue: Bool) {
        if newValue || canCreateWeek {
            paginateWeek()
        }
    }
    
    func onSelectDate(at index: Int) {
        selectedDate = index
    }
}
