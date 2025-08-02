//
//  CalendarTaskCRUDManager.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 31/07/2025.
//

import SwiftUI
import SwiftData

@Observable
class CalendarTaskCRUDManager {
    
    var calendarTasks: [CalendarTask]
    
    init(calendarTasks: [CalendarTask]) {
        self.calendarTasks = calendarTasks
    }
    
    func add(_ event: CalendarTask) {
        let taskRanges = calendarTasks.reduce(into: Set<Range<Date>>()) { result, task in
            result.insert(task.start..<task.end)
        }
        let eventRange = event.start..<event.end
        for range in taskRanges {
            if eventRange.overlaps(range) {
                return
            }
        }
        self.calendarTasks.append(event)
        self.calendarTasks = self.calendarTasks.sorted(by: { $0.start < $1.start })
    }
    
    func remove(_ event: CalendarTask) {
        if let index = calendarTasks.firstIndex(where: { $0.id == event.id }) {
            self.calendarTasks.remove(at: index)
        }
    }
    
    func remove(at offset: IndexSet) {
        self.calendarTasks.remove(atOffsets: offset)
    }
    
    func edit(with id: UUID,
              _ start: Date?,
              _ end: Date?,
              _ title: String?,
              _ description: String?
    ) {
        if let index = calendarTasks.firstIndex(where: { $0.id == id }) {
            let selected = self.calendarTasks[index]
            self.calendarTasks[index].start =  start ?? selected.start
            self.calendarTasks[index].end =  end ?? selected.end
            self.calendarTasks[index].title =  title ?? selected.title
            self.calendarTasks[index].eventDescription =  description ?? selected.eventDescription
        }
    }
}
