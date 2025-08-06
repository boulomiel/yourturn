//
//  WeekDayCalendarObs.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import Foundation
import SBExtensions
import SwiftUI

@Observable
class WeekDayCalendarObs {
    
    let currentSelectedDate: Date
    var calendarTasks: [CalendarTask]
    
    init(currentSelectedDate: Date, in tasks: [CalendarTask]) {
        self.currentSelectedDate = currentSelectedDate
        self.calendarTasks = tasks
    }
}
