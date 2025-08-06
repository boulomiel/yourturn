//
//  CalendarTaskPreviewModifier.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 31/07/2025.
//


import SwiftUI
import SwiftData
import SBHistory

struct CalendarTaskPreviewModifier: PreviewModifier {
    
    static let modelContainer = Preview().modelContainer
    static let history = Preview().history

    static func makeSharedContext() async throws -> ModelContainer {
        try await createMockData(in: modelContainer.mainContext)
        return modelContainer
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
            .environment(Self.history)
            .environment(FloattingButtonActionHandler())
            .environment(CalendarTaskCRUDManager(calendarTasks: []))
    }
    
    private static func createMockData(in context: ModelContext) async throws {
        let calendarTask = CalendarTask.mockEventsForCurrentWeek()
//        let sbActivities = calendarTask.map { task -> SBActivity in
//                .init(title: task.title,
//                      taskDescription: task.eventDescription,
//                      startDate: task.start,
//                      endDate: task.end)
//        }
        for activity in calendarTask {
            try await history.insert(activity)
        }
        
        try await history.save()
    }
    
}
