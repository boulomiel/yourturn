//
//  CalendarTask.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import Foundation

struct CalendarTask: Identifiable, Hashable {
    
    enum TimeState {
        case upcoming
        case ongoing
        case completed
    }
    
    let id: UUID = .init()
    var start: Date
    var end: Date
    var title: String
    var eventDescription: String?
    
    var timeState: TimeState {
        if end < .now {
            .completed
        } else if start <= .now && end > .now {
            .ongoing
        } else {
            .upcoming
        }
    }
    
    static func mockEventsForCurrentWeek() -> [CalendarTask] {
        let calendar = Calendar.current
        let now = Date()
        
        // Start of the current week (Monday at 00:00)
        guard let startOfWeek = now.fetchWeek().first?.date else {
            return []
        }
        
        var events: [CalendarTask] = []
        let titles: [String] = [
            "Team Standup", "Design Review", "Sprint Planning", "Client Call",
            "Backend Sync \nBecause we need it.", "Lunch & Learn", "Mobile Demo", "1:1 with Manager",
            "Retrospective", "Weekly Wrap-Up",
            "Code Review", "Product Demo", "Marketing Meeting", "HR Check-in", "Budget Review",
            "Client Feedback", "Tech Sync", "QA Session", "Deployment", "Team Lunch"
        ]
        
        let hourOffsets = [8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 9, 12, 13, 14, 10, 11, 15, 16, 17]
        
        for i in 0..<40 {
            // Spread events across 5 days, 4 per day (Mon-Fri)
            let dayOffset = i / 4
            let hourOffset = hourOffsets[i % hourOffsets.count]
            let title = titles[i % titles.count]
            
            let startTime = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)!
            let eventStart = calendar.date(byAdding: .hour, value: hourOffset, to: startTime)!
            let eventEnd = calendar.date(byAdding: .hour, value: 1, to: eventStart)! // 1-hour event
            
            let event = CalendarTask(
                start: eventStart,
                end: eventEnd,
                title: title,
                eventDescription: "This is \(title) \n We also love the you are.\nBeen doing nice stuff lately"
            )
            events.append(event)
        }
        
        return events
    }
}
