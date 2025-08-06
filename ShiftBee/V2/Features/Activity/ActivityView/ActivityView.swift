//
//  ActivityView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 31/07/2025.
//

import SwiftUI
import SwiftData
import MapKit

typealias NewActivityRouter = Router<ActivityRoute, ActivitySheet, ActivityPopover>

struct ActivityView: View {
        
    @State private var router: NewActivityRouter = .init()
    @State private var titleField: String = ""
    @State private var descriptionField: String = ""
    @State private var startDate: Date = .now
    @State private var endDate: Date = .now

    private var title: String {
        calendarTask?.title ?? "New Task"
    }
    
    var calendarTask: CalendarTask?
        
    var body: some View {
        RoutingView(navigator: router) {
            Form {
                Section {
                    TextField("", text: $titleField)
                } header: {
                    ActivityFormHeaders.title.view
                }

                Section {
                    TextEditor(text: $descriptionField)
                } header: {
                    ActivityFormHeaders.description.view
                }
                
                Section {
                    DatePicker("Start", selection: $startDate)
                    DatePicker("End", selection: $startDate)
                } header: {
                    ActivityFormHeaders.dateAndTime.view
                }
                
                Section {

                } header: {
                    ActivityFormHeaders.location.view
                } footer: {
                    Button {
                        router.push(.mapView)
                    } label: {
                        Text("Add location")
                            .frame(maxWidth: .infinity, maxHeight: 80)
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .navigationTitle(title)
        }

    }
}



#Preview {
    ActivityView(calendarTask: CalendarTask.mockEventsForCurrentWeek().first)
        .preferredColorScheme(.dark)
        .environment(ShiftBeeLocationManager())
}


