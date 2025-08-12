//
//  SBTimeline.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 08/05/2025.
//

import SwiftData
import SwiftUI

struct SBTimeline: View {
    
    @Bindable var obs: SBHourShiftObs
    
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
    SBTimeline(obs:.init(modelContainer: moc.container, date: .now))
}
