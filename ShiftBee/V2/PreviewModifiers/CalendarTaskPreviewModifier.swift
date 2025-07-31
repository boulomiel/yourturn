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
    
    static func makeSharedContext() async throws -> ModelContainer {
        let modelContainer = Preview().modelContainer
        try createMockData(in: modelContainer.mainContext)
        return modelContainer
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
    
    private static func createMockData(in context: ModelContext) throws {
        let calendarTask = CalendarTask.mockEventsForCurrentWeek()
        let sbActivities = calendarTask.map { task -> SBActivity in
                .init(title: task.title,
                      taskDescription: task.eventDescription,
                      startDate: task.start,
                      endDate: task.end)
        }
        sbActivities.forEach { activity in
            context.insert(activity)
        }
        
        try context.save()
    }
    
}
