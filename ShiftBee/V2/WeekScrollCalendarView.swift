//
//  WeekScrollCalendarView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 28/07/2025.
//

import SBExtensions
import SwiftUI

struct WeekScrollCalendarView: View {
    
    @State private var obs: WeekScrollCalendarObs
    @Namespace private var selectedDateNamespace
    
    // Constants
    let weekCreationOffset: CGFloat = 15
    
    init(obs: WeekScrollCalendarObs = .init(startDate: .now)) {
        self.obs = obs
    }
    
    var body: some View {
        VStack {
            HeaderView()
            WeekSliderView()
            WeekDayCalendarView(obs: .init(currentSelectedDate: obs.headerDate))
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        let date = obs.headerDate
        VStack(alignment: .leading) {
            Text(date.fullMonth)
                .font(.title2.bold())
            
            Text(date.year)
                .font(.body.bold())
                .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, weekCreationOffset)
    }
    
    func WeekSliderView() -> some View {
        TabView(selection: $obs.selectedWeekIndex){
            ForEach(Array(obs.currentWeeks.enumerated()), id: \.0) { index, week in
                WeekView(week: week)
                    .id(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: obs.selectedWeekIndex, initial: false, obs.onSelectedWeekIndexChange(_:newIndex:))
        .frame(height: 100)
    }
    
    func WeekView(week: [WeekDay]) -> some View {
        HStack {
            ForEach(Array(week.enumerated()), id: \.0) { index, weekDayDate in
                VStack {
                    VStack {
                        Text("\(weekDayDate.date.weekDay)")
                            .font(.system(size: 13).bold())
                        
                        Text("\(weekDayDate.date.dayNumber)")
                            .font(.system(size: 18).bold())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background {
                        if obs.selectedDate == index {
                            Circle()
                                .fill(Color.blue)
                                .glassEffect()
                                .matchedGeometryEffect(id: "SelectedDate", in: selectedDateNamespace)
                        }
                    }
                    
                    Circle()
                        .fill(weekDayDate.date.isToday() ? Color.red : .clear)
                        .frame(width: 4, height: 4)
                    
                }
                .onTapGesture{
                    withAnimation {
                        obs.onSelectDate(at: index)
                    }
                }
                .id(weekDayDate.id)
            }
        }
        .onGeometryChange(for: Bool.self, of: { geo in
            abs(geo.frame(in: .global).width - geo.frame(in: .global).maxX) == weekCreationOffset
        }, action: obs.onSwipe)
        
        .onGeometryChange(for: Bool.self, of: { geo in
            abs(geo.frame(in: .global).minX) == weekCreationOffset
        }, action: obs.onSwipe)
        .padding(.horizontal, weekCreationOffset)
    }
}

@Observable
class WeekScrollCalendarObs {
    
    var selectedWeekIndex: Int
    var currentWeeks: [[WeekDay]]
    var selectedDate: Int?
    private var canCreateWeek: Bool = false
    
    var headerDate: Date {
        currentWeeks[selectedWeekIndex][selectedDate ?? 0].date
    }
    
    init(startDate: Date) {
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

@Observable
class WeekDayCalendarObs {
    
    var calendarTasks: [CalendarTask] = []
    
    init(currentSelectedDate: Date) {
        withAnimation {
            self.calendarTasks = CalendarTask.mockEventsForCurrentWeek().filter { $0.start.isSameDay(as: currentSelectedDate ) }.sorted(by: { $0.start < $1.start })
        }
    }
    
    func add(_ event: CalendarTask) {
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

struct WeekDayCalendarView: View {
    
    private var obs: WeekDayCalendarObs
    @Namespace private var emptyTaskUnion
    @Namespace private var indicator
    @Namespace var rowSpace
    
    init(obs: WeekDayCalendarObs) {
        self.obs = obs
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                let frame = geo.frame(in: .global)
                TaskContent(width: frame.width, height: frame.height)
            }
            .safeAreaPadding(.all)
        }
    }
    
    @ViewBuilder
    private func TaskContent(width: CGFloat, height: CGFloat) -> some View {
        if obs.calendarTasks.isEmpty {
            TaskEmptyListView(width: width, height: height)
        } else {
            LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                ForEach(obs.calendarTasks, id: \.self) { event in
                    Section {
                        TaskRow(event)
                    } header: {
                        TaskHeader(event)
                    }
                    .transition(.slide)
                }
            }
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
                .offset(x: -4)
                .glassEffectUnion(id: "scroll", namespace: indicator)
            
            
            Text(event.start.formatted(date: .omitted, time: .shortened))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func TaskEmptyListView(width: CGFloat, height: CGFloat) -> some View {
        VStack(alignment: .center) {
            GlassEffectContainer {
                Image(systemName: "beach.umbrella")
                    .font(.system(size: 120))
                    .foregroundStyle(.blue.gradient)
                    .glassEffect()
                    .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "cup.and.heat.waves.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue.gradient)
                            .glassEffect()
                            .offset(x: -20)
                            .glassEffectUnion(id: "EmptyTask", namespace: emptyTaskUnion)
                        
                    }
            }
        }
        .frame(width: width, height: height)
        .background(Color.red)
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

#Preview {
    WeekScrollCalendarView()
}
