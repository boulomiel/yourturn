//
//  WeekScrollCalendarObs.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import OSLog
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
    
    var dailyCalendarTasks: [CalendarTask] = []

    private var canCreateWeek: Bool = false
    private let history: SBHistoryManager
    
    var headerDate: Date {
        currentWeeks[selectedWeekIndex][selectedDate ?? 0].date
    }
    
    init(startDate: Date, history: SBHistoryManager) {
        self.history = history
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
    
    func updateDailyCalendarTask() async {
        let startDate = headerDate
        let endDate = startDate.addingTimeInterval(60 * 60 * 24)
        let predicate = #Predicate<SBActivity> { activity in
            activity.startDate >= startDate && activity.endDate < endDate
        }
        do {
            let calendarTasks = try await history.fetch(predicate: predicate, sortDescriptors: [.init(\.startDate, order: .forward)])
            dailyCalendarTasks = calendarTasks
        } catch {
            ShiftBeeApp.logger.error("\(#function) - \(error)")
            dailyCalendarTasks = []
        }
    }
    
    func observeDailyTasks() async {
        for await new in NotificationCenter.default.messages(of: history, for: SBHistoryManager.LastInsertedMessage<CalendarTask>.self) {
            let id = new.id
            let date = Date(timeIntervalSince1970: new.lastItemTimestamp)
            guard date.isSameDay(as: headerDate) else {
                continue
            }
            do {
                guard let newsTask = try await history.fetch(predicate: #Predicate<SBActivity> { $0.domainId == id }, sortDescriptors: [], fetchLimit: 1).first else{
                    continue
                }
                var newCalendarTasks = dailyCalendarTasks
                newCalendarTasks.append(newsTask)
                newCalendarTasks.sort { $0.start < $1.start }
                dailyCalendarTasks = newCalendarTasks
            } catch {
                ShiftBeeApp.logger.error("\(#function) - \(error)")
            }
        }
    }
}
