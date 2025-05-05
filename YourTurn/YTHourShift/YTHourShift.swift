//
//  YTHourShift.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

import SwiftUI


struct YTHourShift: View {
    
    @State var obs: YTHourShiftObs
    
    var body: some View {
        NavigationStack {
            tabs
                .onAppear {
                    obs.fetchDateList()
                }
                .toolbar {
                    if let fileURL = obs.shareLink {
                        ToolbarItem(placement: .topBarTrailing) {
                            ShareLink(item: fileURL) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.gradient.opacity(1.0))
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .overlay {
                                        Label("Share list", systemImage: "square.and.arrow.up")
                                    }
                            }
                            .transition(.scale)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        YTSegmentedControlView(cases: YTShiftCase.allCases, selectedCase: $obs.shiftCase)
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        YTPopupView(state: obs.popupState)
                    }
                }
        }
    }
    
    @ViewBuilder
    var personList: some View {
        YTPersonListView(obs:.init(person: obs.persons)) { names in
            withAnimation {
                obs.persons = names
            }
        }
        .onChange(of: obs.persons, { oldValue, newValue in
            obs.timePerPerson()
        })
        .onAppear {
            obs.timePerPerson()
        }
        .tag(YTShiftCase.persons)
    }
    
    @ViewBuilder
    var tabs: some View {
        TabView(selection: $obs.shiftCase) {
            timeline
                .tag(YTShiftCase.time)
            
            personList
                .tag(YTShiftCase.persons)
        }
        .tabViewStyle(.automatic)
    }
    
    @ViewBuilder
    var timeline: some View {
        Form {
            DatePicker("Start", selection: $obs.startHour, displayedComponents: [.date, .hourAndMinute])
            DatePicker("End", selection: $obs.endHour, displayedComponents: [.date, .hourAndMinute])
        }
        .onChange(of: obs.startHour, { _, _ in
            obs.updateTime()
        })
        .onChange(of: obs.endHour, { _, _ in
            obs.updateTime()
        })
//        .overlay(alignment: .bottom) {
//            YTPopupView(state: obs.popupState)
//        }
        .onAppear {
            obs.updateTime()
        }
    }
}



extension TimeInterval {
    
    var hoursAndMinutesPeriod: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self)
    }
}

extension Date {
    
    var hoursAndMinutesPeriod: String {
        let formatter = DateComponentsFormatter()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: components) ?? hoursAndMinutesFormatted
    }
    
    var hoursAndMinutesFormatted: String {
        self.formatted(date: .omitted, time: .shortened)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var moc
    YTHourShift(obs: .init(modelContainer: moc.container, date: .now))
        .preferredColorScheme(.dark)
}
