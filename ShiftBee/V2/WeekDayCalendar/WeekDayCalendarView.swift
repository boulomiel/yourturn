//
//  WeekDayCalendarView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 29/07/2025.
//

import SwiftUI

struct WeekDayCalendarView: View {
    
    @Environment(FloattingButtonActionHandler.self) var floatingActionHandler
    
    private var obs: WeekDayCalendarObs
    @Namespace private var indicator
    @Namespace var rowSpace
    
    init(obs: WeekDayCalendarObs) {
        self.obs = obs
    }
    
    var body: some View {
            ScrollView {
                TaskContent()
            }
            .safeAreaPadding(.all)
            .onAppear {
                floatingActionHandler.onJumpToToDay = { print("on Jump To ToDay")}
                floatingActionHandler.onShowCalendarList = { print("Show Caledar List") }
            }
        
    }
    
    @ViewBuilder
    private func TaskContent() -> some View {
        if obs.calendarTasks.isEmpty {
            EmptyDailyView()
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
