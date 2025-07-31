//
//  ContentViewV2.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 30/07/2025.
//

import SwiftUI
import SBHistory

struct ContentViewV2: View {
    
    @Environment(\.modelContext) var context
    @State private var router: BaseRouter = .init()
    let floatingActionHandler: FloattingButtonActionHandler = .init()
    
    var body: some View {
        RoutingView(navigator: router) {
            WeeklyCalendarView()
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    FloatingButton {
                        FloatingButtonItem(
                            label: "Add Event",
                            systemImage: "calendar.badge.plus",
                            action: {
                                context.insert(SBActivity(title: "Test", taskDescription: "Because now time has come to testing proogress", startDate: .now, endDate: .now.addingTimeInterval(3600 * 3)))
                                try? context.save()
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
                // Replace by fetched data from SwifData
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

