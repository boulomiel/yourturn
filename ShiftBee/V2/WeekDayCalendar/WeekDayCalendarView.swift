//
//  WeekDayCalendarView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import SwiftUI
import SwiftData
import SBHistory



struct WeekDayCalendarView: View {
    
    @Environment(FloattingButtonActionHandler.self) var floatingActionHandler
    @Environment(\.modelContext) private var moc
    
    @Namespace private var indicator
    @Namespace private var rowSpace
    @Query private var activities: [SBActivity]
    
    init(currentSelectedDate: Date) {
        let startDate = currentSelectedDate
        let endDate = startDate.addingTimeInterval(60 * 60 * 24)
        let predicate = #Predicate<SBActivity> { activity in
            activity.startDate >= startDate && activity.endDate < endDate
        }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [.init(\.startDate, order: .forward)])
        self._activities = .init(descriptor, animation: .default)
    }
    
    var body: some View {
        TaskContent()
            .safeAreaPadding(.all)
            .onAppear {
                floatingActionHandler.onJumpToToDay = { print("on Jump To ToDay")}
                floatingActionHandler.onShowCalendarList = { print("Show Caledar List") }
            }
        
    }
    
    @ViewBuilder
    private func TaskContent() -> some View {
        let calendarTasks = activities.map { activity -> CalendarTask in .init(id: activity.id, start: activity.startDate, end: activity.endDate, title: activity.title, eventDescription: activity.taskDescription) }
        if calendarTasks.isEmpty {
            ScrollView {
                EmptyDailyView()
            }
        } else {
            List {
                ForEach(calendarTasks, id: \.self) { event in
                    Section {
                        TaskRow(event)
                    } header: {
                        TaskHeader(event)
                    }
                }
                .onDelete(perform: { indexSet in
                    let calendarTask = calendarTasks[indexSet.count-1]
                    guard let toRemove = activities.first(where: { $0.id == calendarTask.id }) else {
                        return
                    }
                    do {
                        moc.delete(toRemove)
                        try moc.save()
                    } catch {
                        ShiftBeeApp.logger.error("\(#function) - \(error)")
                    }
                })
                .listSectionSeparator(.hidden)
                .listSectionSpacing(.compact)
                .listRowBackground(Color.clear)
            }
            .listStyle(.inset)
        }
    }
    
    private func TaskRow(_ event: CalendarTask) -> some View {
        
        HStack {
            GeometryReader { geo in
                let frame = geo.frame(in: .named(rowSpace))
                Rectangle()
                    .fill(TaskColor(event.timeState).gradient)
                    .frame(width: 4, height: frame.height * 0.9)
                    .glassEffect(.regular.interactive())
                    .glassEffectUnion(id: "scrollUnion", namespace: indicator)
            }
            .frame(width: 4)
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(event.title)
                    .font(.title3.bold())
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(event.eventDescription ?? "")
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.gradient))
        }
        .coordinateSpace(name: rowSpace)
    }
    
    private func TaskHeader(_ event: CalendarTask) -> some View {
        HStack {
            Circle()
                .fill(TaskColor(event.timeState))
                .frame(width: 12, height: 12, alignment: .leading)
                .glassEffect()
                .glassEffectUnion(id: "scroll", namespace: indicator)
            
            
            Text(event.start.formatted(date: .omitted, time: .shortened))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .offset(x: 4)
    }
    
    private func TaskColor(_ timeState: CalendarTask.TimeState) -> Color {
        switch timeState {
        case .upcoming:
                .blue
        case .ongoing:
                .green
        case .completed:
                .gray.opacity(0.4)
        }
    }
}


#Preview(traits: .modifier(CalendarTaskPreviewModifier())) {
//    WeeklyCalendarView()
//        .environment(FloattingButtonActionHandler())
//        .environment(CalendarTaskCRUDManager(calendarTasks: []))
    ContentViewV2()
}
