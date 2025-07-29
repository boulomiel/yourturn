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

#Preview {
    WeekScrollCalendarView()
}
