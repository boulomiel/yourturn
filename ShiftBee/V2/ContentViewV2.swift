//
//  ContentViewV2.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI
import SBHistory

struct ContentViewV2: View {
    
    @Environment(SBHistoryManager.self) var history
    @Environment(\.modelContext) var context
    @State private var router: MainRouter = .init()
    let floatingActionHandler: FloattingButtonActionHandler = .init()
    
    var body: some View {
        RoutingView(navigator: router) {
            WeeklyCalendarView(obs: .init(startDate: .now, history: history))
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    FloatingButton {
                        FloatingButtonItem(
                            label: "Add Event",
                            systemImage: "calendar.badge.plus",
                            action: {
                                Task {
                                    let calendarTask = CalendarTask(id: .init(), timestamp: Date.now.timeIntervalSince1970, start: .now, end: .now.addingTimeInterval(3600 * 3), title: "Test", eventDescription: "Because now time has come to testing proogress")
                                    try await history.insert(calendarTask)
                                }
//                                context.insert(SBActivity(title: "Test", taskDescription: "Because now time has come to testing proogress", startDate: .now, endDate: .now.addingTimeInterval(3600 * 3)))
//                                try? context.save()
                                // Code to add a new event
                            }
                        )
                        
                        FloatingButtonItem(
                            label: "Today",
                            systemImage: "calendar",
                            action: {
                                floatingActionHandler.onJumpToToDay()
                                // Code to jump to today's date
                            }
                        )
                        
                        FloatingButtonItem(
                            label: "Calendars",
                            systemImage: "list.bullet",
                            action: {
                                floatingActionHandler.onShowCalendarList()
                                // Code to show calendar list
                            }
                        )
                    }
                    .padding(.horizontal, 8)
                }
                .environment(floatingActionHandler)
                .environment(CalendarTaskCRUDManager(calendarTasks: []))
        }

    }
}

@Observable
class FloattingButtonActionHandler {

    var onJumpToToDay: () -> Void = {}
    var onShowCalendarList: () -> Void =  {}
}


#Preview(traits: .modifier(CalendarTaskPreviewModifier())) {
    ContentViewV2()
}

