//
//  YTTimeline.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftUI

struct YTTimeline: View {
    
    @Bindable var obs: YTHourShiftObs
    
    var body: some View {
        Form {
            Section {
                DatePicker("Start", selection: $obs.startHour, in: obs.startHour..., displayedComponents: [.date, .hourAndMinute])
                DatePicker("End", selection: $obs.endHour, displayedComponents: [.date, .hourAndMinute])
            } header: {
                Text("Duration")
            }
            
        }
        .onChange(of: obs.startHour, { _, _ in
            obs.updateTime()
        })
        .onChange(of: obs.endHour, { _, _ in
            obs.updateTime()
        })
        .onAppear {
            obs.updateTime()
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var moc
    YTTimeline(obs:.init(modelContainer: moc.container, date: .now))
}
